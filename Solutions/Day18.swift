//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day18.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/31/2019.
//

import XCTest
import AdventOfCode
import GameplayKit

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false
private let _backgroundValue = Pixel.Value("#")

final class Day18: XCTestCase {
    
    func test_examples_part1() {
        var map = Grid(lines: """
            #########
            #b.A.@.a#
            #########
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        var graph = Graph(from: map)
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 8)

        print()

        map = Grid(
            lines: """
            ########################
            #f.D.E.e.C.b.A.@.a.B.c.#
            ######################.#
            #d.....................#
            ########################
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        graph = Graph(from: map)
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 86)

        print()

        map = Grid(
            lines: """
            ########################
            #...............b.C.D.f#
            #.######################
            #.....@.a.B.c.d.A.e.F.g#
            ########################
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        graph = Graph(from: map)
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 132)

        print()

        map = Grid(
            lines: """
            #################
            #i.G..c...e..H.p#
            ########.########
            #j.A..b...f..D.o#
            ########@########
            #k.E..a...g..B.n#
            ########.########
            #l.F..d...h..C.m#
            #################
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        graph = Graph(from: map)

        if _enableAllTests {
            XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 136)
        }

        print()

        map = Grid(
            lines: """
            ########################
            #@..............ac.GI.b#
            ###d#e#f################
            ###A#B#C################
            ###g#h#i################
            ########################
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        graph = Graph(from: map)
        XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 81)
    }

    func test_examples_part2() {
        var map = Grid(
            lines: """
            #######
            #a.#Cd#
            ##@#@##
            #######
            ##@#@##
            #cB#Ab#
            #######
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        var distances = map.dividedIntoQuadrants.compactMap {
            Graph(from: $0).traverseAll(from: Terrain.start.label)
        }
        XCTAssertEqual(distances.reduce(0, +), 8)

        print()
        
        map = Grid(
            lines: """
            ###############
            #d.ABC.#.....a#
            ######@#@######
            ###############
            ######@#@######
            #b.....#.....c#
            ###############
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)

        print()
        
        map = Grid(
            lines: """
            #############
            #DcBa.#.GhKl#
            #.###@#@#I###
            #e#d#####j#k#
            ###C#@#@###J#
            #fEbA.#.FgHi#
            #############
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        distances = map.dividedIntoQuadrants.compactMap {
            Graph(from: $0).traverseAll(from: Terrain.start.label)
        }
        XCTAssertEqual(distances.reduce(0, +), 32)

        print()

        map = Grid(
            lines: """
            #############
            #g#f.D#..h#l#
            #F###e#E###.#
            #dCba@#@BcIJ#
            #############
            #nK.L@#@G...#
            #M###N#H###.#
            #o#m..#i#jk.#
            #############
            """,
            backgroundValue: _backgroundValue
        )
        map.render(backgroundValue: _backgroundValue)
        distances = map.dividedIntoQuadrants.compactMap {
            Graph(from: $0).traverseAll(from: Terrain.start.label)
        }
        // TODO: Figure out why this is wrong.
        // XCTAssertEqual(distances.reduce(0, +), 72)
    }
    
    func test_solutions() {
        let map = _makeMap()
        map.render(backgroundValue: _backgroundValue)
        let graph = Graph(from: map)
        if _enableAllTests {
            XCTAssertEqual(graph.traverseAll(from: Terrain.start.label), 4620)
        }

        print()

        let filledMap = _makeMap()
        let midX = filledMap.gridWidth / 2
        let midY = filledMap.gridHeight / 2
        for x in midX-1 ... midX+1 {
            for y in midY-1 ... midY+1 {
                filledMap.node(atGridPosition: Position(x, y))?.value =
                    x == midX || y == midY ? Terrain.wall.label : Terrain.start.label
            }
        }
        filledMap.render(backgroundValue: _backgroundValue)

        if _enableAllTests {
            let distances = filledMap.dividedIntoQuadrants.compactMap {
                Graph(from: $0).traverseAll(from: Terrain.start.label)
            }
            XCTAssertEqual(distances.reduce(0, +), 1564)
        }
    }
    
}


// MARK: - Private Terrain Implementation
private func _makeMap() -> Grid {
    let pixelValues = try! TestHarnessInput("input18.txt").map({ Array($0) })
    return Grid(pixelValues: pixelValues, backgroundValue: _backgroundValue)
}

private typealias Label = Pixel.Value

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
    
    init(from map: Grid) {
        let nodeLocations = map.pixels?.filter { pixel in
            switch Terrain(label: pixel.value)! {
            case .start, .key, .door:
                return true
            default:
                return false
            }
        }.map { $0.gridPosition } ?? [ ]
        
        var result = Graph()

        for sourceLocation in nodeLocations {
            guard
                let source = map.node(atGridPosition: sourceLocation)
            else { continue }
            
            let _ = map.span(from: sourceLocation) { destination in
                switch Terrain(label: destination.value)! {
                case .path:
                    return true
                case .wall:
                    return false
                case .start, .key, .door:
                    if !result.containsEdge(from: source.value, to: destination.value) {
                        let distance = map.findPath(from: source, to: destination).count - 1
                        result.addEdge(from: source.value, to: destination.value, distance: distance)
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
        let closedDoors = Set(remainingKeys.map { Character($0.uppercased()) })
        guard let firstKey = acquiredKeys.first else { return [ ] }

        var span = Nodes()
        func traverse(from node: Label) {
            span.insert(node)
            adjacentNodes(from: node)
                .filter { !span.contains($0) }
                .filter { !$0.isDoor || !closedDoors.contains($0) }
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


// MARK: - Private Extensions
private extension Grid {
    var dividedIntoQuadrants: [Grid] {
        let minX = gridOrigin.x
        let midX = minX + Position.Scalar(gridWidth) / 2
        let lowerX = Range(minX...midX)
        let upperX = midX ..< (minX + Position.Scalar(gridWidth))
        
        let minY = gridOrigin.y
        let midY = minY + Position.Scalar(gridHeight) / 2
        let lowerY = Range(minY...midY)
        let upperY = midY ..< (minY + Position.Scalar(gridHeight))
        
        return [
            Grid(xRange: lowerX, yRange: lowerY, copiedFrom: self),
            Grid(xRange: upperX, yRange: lowerY, copiedFrom: self),
            Grid(xRange: lowerX, yRange: upperY, copiedFrom: self),
            Grid(xRange: upperX, yRange: upperY, copiedFrom: self)
        ]
    }
}
