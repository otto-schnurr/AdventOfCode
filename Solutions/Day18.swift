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
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 8)
        
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
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 86)

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

private typealias Label = Screen.Pixel

private enum Terrain {
    
    case start
    case wall
    case path
    case key(Label)
    case door(Label)
    
    init?(label: Label) {
        switch label {
        case "@": self = .start
        case "#": self = .wall
        case ".": self = .path
        case "a"..."z": self = .key(label)
        case "A"..."Z": self = .door(label)
        default: return nil
        }
    }
    
}

private extension Terrain {
    
    var label: Label {
        switch self {
        case .start:
            return "@"
        case .wall:
            return "#"
        case .path:
            return "."
        case .key(let label):
            return label
        case .door(let label):
            return label
        }
    }
    
}

// MARK: - Private Graph Implementation
private typealias Graph = [Label: [Edge]]

private struct Edge {
    
    let destination: Label
    let distance: Int
    let requiredKeys: Set<Label>
    
    init(destination: Label, distance: Int, requiredKeys: Set<Label> = [ ]) {
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

private extension Label {
    var isDoor: Bool {
        guard let terrain = Terrain(label: self) else { return false }
        switch terrain {
        case .door: return true
        default: return false
        }
    }
}

private extension Graph {
    
    var keyNodes: Set<Label> { Set(keys.filter { !$0.isDoor }) }
    
    init(from map: Screen) {
        let nodeLocations = map.allCoordinates { pixel in
            switch Terrain(label: pixel)! {
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
                switch Terrain(label: pixelValue)! {
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

    // MARK: Query
    func containsEdge(from source: Label, to destination: Label) -> Bool {
        guard let edges = self[source] else { return false }
        return edges.contains { edge in edge.destination == destination }
    }
    
    // reference: https://www.reddit.com/r/adventofcode/comments/ec8090/2019_day_18_solutions/fbd8y0b/
    func traverseAll(from start: Label) -> Int? {
        let remainingKeys = keyNodes.subtracting([start])
        return distanceToCollect(remainingKeys, from: start)
    }
    
    func distance(from start: Label, to end: Label) -> Int? {
        var visitedNodes = Set([start])
        var queue = [start]
        var distanceTable = [start: 0]
         
        while let node = queue.popLast(), let distance = distanceTable[node] {
            let edges = self[node]?.filter {
                !visitedNodes.contains($0.destination)
            } ?? [ ]
            let adjacentNodes = edges.map { $0.destination }
             
            visitedNodes = visitedNodes.union(adjacentNodes)
            queue = adjacentNodes + queue
            edges.forEach {
                let previousDistance = distanceTable[$0.destination] ?? Int.max
                distanceTable[$0.destination] = Swift.min(previousDistance, distance + $0.distance)
            }
        }
         
        return distanceTable[end]
    }

    func availableKeys(from remainingKeys: Set<Label>) -> Set<Label> {
        let acquiredKeys = keyNodes.subtracting(remainingKeys)
        let openDoors = acquiredKeys.map { Character($0.uppercased()) }
        let availableKeys = filter {
            acquiredKeys.contains($0.key) || openDoors.contains($0.key)
        }.map { $0.value }.flatMap { $0 }.map { $0.destination }.filter {
            remainingKeys.contains($0)
        }
        
        return Set(availableKeys)
    }

    func distanceToCollect(_ remainingKeys: Set<Label>, from key: Label) -> Int {
        guard !remainingKeys.isEmpty else { return 0 }

        return availableKeys(from: remainingKeys).map { nextKey in
            guard let nextDistance = self.distance(from: key, to: nextKey) else {
                return Int.max
            }
            return nextDistance + distanceToCollect(remainingKeys.subtracting([nextKey]), from: nextKey)
        }.min(by: <) ?? Int.max
    }

    // MARK: Edit
    mutating func addEdge(
        from source: Label, to destination: Label, distance: Int
    ) {
        if self[source] == nil { self[source] = [Edge]() }
        self[source]?.append(Edge(destination: destination, distance: distance))

        if self[destination] == nil { self[destination] = [Edge]() }
        self[destination]?.append(Edge(destination: source, distance: distance))
    }
    
}
