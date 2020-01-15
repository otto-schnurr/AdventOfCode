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
            prefix + ", required keys: \(requiredKeys))"
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
        let nodeLocations = map.allCoordinates { pixel in
            switch Terrain(pixelValue: pixel)! {
            case .start, .key, .door:
                return true
            default:
                return false
            }
        }
        
        var result = Graph()

        for sourceLocation in nodeLocations {
            let source = map[sourceLocation]
            
            let _ = map.spanPath(from: sourceLocation) { pixelValue, distance in
                switch Terrain(pixelValue: pixelValue)! {
                case .path:
                    return true
                case .wall:
                    return false
                case .start, .key, .door:
                    if !result.containsEdge(from: source, to: pixelValue) {
                        result.addEdge(from: source, to: pixelValue, distance: distance)
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
    
    mutating func addEdge(
        from source: NodeLabel, to destination: NodeLabel, distance: Int
    ) {
        if self[source] == nil { self[source] = [Edge]() }
        self[source]?.append(Edge(destination: destination, distance: distance))

        if self[destination] == nil { self[destination] = [Edge]() }
        self[destination]?.append(Edge(destination: source, distance: distance))
    }
    
}
