//
//  Day18.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day18: XCTestCase {
    
    func test_examples() {
        var map = Screen(lines: """
        #########
        #b.A.@.a#
        #########
        """)!
        map.render()
        var graph = Graph(from: map)
        print(graph)
        print(graph.coelescedWithoutDoors())
        
        map = Screen(lines: """
        ########################
        #f.D.E.e.C.b.A.@.a.B.c.#
        ######################.#
        #d.....................#
        ########################
        """)!
        map.render()
        graph = Graph(from: map)
        print(graph)

        map = Screen(lines: """
        ########################
        #...............b.C.D.f#
        #.######################
        #.....@.a.B.c.d.A.e.F.g#
        ########################
        """)!
        map.render()
        graph = Graph(from: map)
        print(graph)

        map = Screen(lines: """
        #################
        #i.G..c...e..H.p#
        ########.########
        #j.A..b...f..D.o#
        ########@########
        #k.E..a...g..B.n#
        ########.########
        #l.F..d...h..C.m#
        #################
        """)!
        map.render()
        graph = Graph(from: map)
        print(graph)

        map = Screen(lines: """
        ########################
        #@..............ac.GI.b#
        ###d#e#f################
        ###A#B#C################
        ###g#h#i################
        ########################
        """)!
        map.render()
        graph = Graph(from: map)
        print(graph)
    }

    func test_solutions() {
        XCTAssertEqual(_map.width, 81)
        XCTAssertEqual(_map.height, 81)
    }
    
}


// MARK: - Private Terrain Implementation
private var _map: Screen = {
    let pixels = try! TestHarnessInput("input18.txt").map({ Array($0) })
    return Screen(pixels: pixels)!
}()

private typealias KeyValue = Screen.Pixel
private typealias DoorValue = Screen.Pixel

private enum Terrain {
    
    case start
    case wall
    case path
    case key(KeyValue)
    case door(DoorValue)
    
    init?(pixelValue: Screen.Pixel) {
        switch pixelValue {
        case "@": self = .start
        case "#": self = .wall
        case ".": self = .path
        case "a"..."z": self = .key(pixelValue)
        case "A"..."Z": self = .door(pixelValue)
        default: return nil
        }
    }
    
}

private extension Terrain {
    
    var pixelValue: Screen.Pixel {
        switch self {
        case .start:
            return "@"
        case .wall:
            return "#"
        case .path:
            return "."
        case .key(let pixelValue):
            return pixelValue
        case .door(let pixelValue):
            return pixelValue
        }
    }
    
}

// MARK: - Private Graph Implementation
private typealias NodeLabel = Screen.Pixel
private typealias Graph = [NodeLabel: [Edge]]

private struct Edge {
    
    let destination: NodeLabel
    let distance: Int
    let requiredKeys: Set<KeyValue>
    
    init(destination: NodeLabel, distance: Int, requiredKeys: Set<KeyValue> = [ ]) {
        self.destination = destination
        self.distance = distance
        self.requiredKeys = requiredKeys
    }
    
}

extension Edge: CustomStringConvertible {
    var description: String {
        let prefix = "(\"\(destination)\", distance: \(distance)"
        return requiredKeys.isEmpty ?
            prefix + ")" :
            prefix + "required keys: \(requiredKeys))"
    }
}

private extension NodeLabel {
    var isDoor: Bool {
        guard let terrain = Terrain(pixelValue: self) else { return false }
        switch terrain {
        case .door: return true
        default: return false
        }
    }
}

private extension Graph {
    
    init(from map: Screen) {
        let rootLocation = map.firstCoordinate { $0 == Terrain.start.pixelValue }!
        let keyAndDoorLocations = map.allCoordinates { pixel in
            switch Terrain(pixelValue: pixel)! {
            case .start, .key: return true
            default:           return false
            }
        }
        
        let nodeLocations = [rootLocation] + keyAndDoorLocations
        var result = Graph()

        for sourceLocation in nodeLocations {
            let sourceIsRoot = sourceLocation == rootLocation
            let source = sourceIsRoot ? Terrain.start.pixelValue : map[sourceLocation]
            
            let _ = map.spanPath(from: sourceLocation) { pixelValue, distance in
                switch Terrain(pixelValue: pixelValue)! {
                case .start, .path:
                    return true
                case .wall:
                    return false
                case .key, .door:
                    if !result.containsEdge(from: source, to: pixelValue) {
                        if sourceIsRoot {
                            result.addDirectedEdge(from: source, to: pixelValue, distance: distance)
                        } else {
                            result.addEdge(from: source, to: pixelValue, distance: distance)
                        }
                    }
                    return false
                }
            }
        }

        self = result
    }

    func containsEdge(
        from source: NodeLabel, to destination: NodeLabel
    ) -> Bool {
        guard let edges = self[source] else { return false }
        return edges.contains { edge in edge.destination == destination }
    }
    
    func destinations(for source: NodeLabel) -> Set<NodeLabel> {
        return Set(self[source]?.map { $0.destination } ?? [ ])
    }

    func coelescedWithoutDoors() -> Graph {
        var result = filter { !$0.key.isDoor }

        for door in filter({ $0.key.isDoor }).map({ $0.key }) {
            let nodesAdjacentToDoor = destinations(for: door)
            
            for adjacentNode in destinations(for: door) {
                let existingNeighbors = result.destinations(for: adjacentNode)

                for newNeighbor in nodesAdjacentToDoor.subtracting(existingNeighbors) {
                    result.combineEdgesDirected(from: adjacentNode, and: newNeighbor, to: door)
                }
            }
        }
        
        return result
    }
    
    mutating func addEdge(
        from source: NodeLabel, to destination: NodeLabel, distance: Int
    ) {
        addDirectedEdge(from: source, to: destination, distance: distance)
        addDirectedEdge(from: destination, to: source, distance: distance)
    }

    mutating func addDirectedEdge(
        from source: NodeLabel, to destination: NodeLabel, distance: Int
    ) {
        if self[source] == nil { self[source] = [Edge]() }
        self[source]?.append(Edge(destination: destination, distance: distance))
    }
    
    mutating func combineEdgesDirected(
        from a: NodeLabel, and b: NodeLabel, to door: NodeLabel
    ) {
        guard
            let edges_a = self[a],
            let index_a = edges_a.firstIndex(where: { $0.destination == door }),
            let edges_b = self[b],
            let index_b = edges_b.firstIndex(where: { $0.destination == door })
        else { return }

        let combinedDistance =
            edges_a[index_a].distance + edges_b[index_b].distance
        let combinedRequirements =
            edges_a[index_a].requiredKeys.union(edges_b[index_b].requiredKeys)
        
        self[a]?[index_a] = Edge(
            destination: b,
            distance: combinedDistance,
            requiredKeys: combinedRequirements
        )
        self[b]?[index_b] = Edge(
            destination: a,
            distance: combinedDistance,
            requiredKeys: combinedRequirements
        )
    }
}
