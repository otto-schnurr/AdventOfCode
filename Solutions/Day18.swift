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


// MARK: - Private
private var _map: Screen = {
    let pixels = try! TestHarnessInput("input18.txt").map({ Array($0) })
    return Screen(pixels: pixels)!
}()

private typealias Graph = [Screen.Pixel: [Edge]]
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

private struct Edge {
    let destination: Screen.Pixel
    let distance: Int
}

extension Edge: CustomStringConvertible {
    var description: String { return "(\"\(destination)\", distance: \(distance))" }
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
        from source: Screen.Pixel, to destination: Screen.Pixel
    ) -> Bool {
        guard let edges = self[source] else { return false }
        return edges.contains { edge in edge.destination == destination }
    }
    
    mutating func addEdge(
        from source: Screen.Pixel, to destination: Screen.Pixel, distance: Int
    ) {
        addDirectedEdge(from: source, to: destination, distance: distance)
        addDirectedEdge(from: destination, to: source, distance: distance)
    }

    mutating func addDirectedEdge(
        from source: Screen.Pixel, to destination: Screen.Pixel, distance: Int
    ) {
        if self[source] == nil { self[source] = [Edge]() }
        self[source]?.append(Edge(destination: destination, distance: distance))
    }
    
}
