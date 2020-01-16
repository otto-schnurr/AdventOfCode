//
//  Day18.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false

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
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 132)

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

        if _enableAllTests {
            XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 136)
        }

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
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 81)
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
private typealias Nodes = Set<Label>

private struct Edge {
    
    let destination: Label
    let distance: Int
    let requiredKeys: Nodes
    
    init(destination: Label, distance: Int, requiredKeys: Nodes = [ ]) {
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

private struct CacheKey: Hashable {
    let remainingKeys: Nodes
    let fromKey: Label
}

private extension Graph {
    
    var keyNodes: Nodes { Set(keys.filter { !$0.isDoor }) }
    
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
    
    func adjacentNodes(from source: Label) -> Nodes {
        return Set(self[source]?.compactMap { $0.destination } ?? [ ])
    }
    
    // reference: https://www.reddit.com/r/adventofcode/comments/ec8090/2019_day_18_solutions/fbd8y0b/
    func traverseAll(from start: Label) -> Int? {
        let remainingKeys = keyNodes.subtracting([start])
        var cache = [CacheKey: Int?]()
        return distanceToCollect(remainingKeys, from: start, cache: &cache)
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

    func availableKeys(from remainingKeys: Nodes) -> Nodes {
        let acquiredKeys = keyNodes.subtracting(remainingKeys)
        let openDoors = Set(acquiredKeys.map { Character($0.uppercased()) })
        guard let firstKey = acquiredKeys.first else { return [ ] }

        var span = Nodes()
        func traverse(from node: Label) {
            span.insert(node)
            adjacentNodes(from: node)
                .filter { !span.contains($0) }
                .filter { !$0.isDoor || openDoors.contains($0) }
                .forEach(traverse)
        }
        traverse(from: firstKey)

        return remainingKeys.intersection(span)
    }

    func distanceToCollect(
        _ remainingKeys: Nodes, from key: Label, cache: inout [CacheKey: Int?]
    ) -> Int? {
        guard !remainingKeys.isEmpty else { return 0 }

        let cacheKey = CacheKey(remainingKeys: remainingKeys, fromKey: key)
        if let cachedResult = cache[cacheKey] { return cachedResult }

        let result: Int? = availableKeys(from: remainingKeys).compactMap { nextKey in
            guard
                let nextDistance = self.distance(from: key, to: nextKey),
                let remainingDistance = distanceToCollect(
                    remainingKeys.subtracting([nextKey]), from: nextKey, cache: &cache
                )
            else { return nil }
            return nextDistance + remainingDistance
        }.min(by: <)
        
        cache[cacheKey] = result
        return result
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
