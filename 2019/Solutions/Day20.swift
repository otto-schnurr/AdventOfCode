//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day20.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/20
//  Created by Otto Schnurr on 1/23/2020.
//

import XCTest
import AdventOfCode
import GameplayKit

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false
private let _backgroundValue = Pixel.Value("#")

final class Day20: XCTestCase {
    
    func test_examples() {
        var pixelValues = Array(arrayLiteral:
            "         A         ",
            "         A         ",
            "  #######.#########",
            "  #######.........#",
            "  #######.#######.#",
            "  #######.#######.#",
            "  #######.#######.#",
            "  #####  B    ###.#",
            "BC...##  C    ###.#",
            "  ##.##       ###.#",
            "  ##...DE  F  ###.#",
            "  #####    G  ###.#",
            "  #########.#####.#",
            "DE..#######...###.#",
            "  #.#########.###.#",
            "FG..#########.....#",
            "  ###########.#####",
            "             Z     ",
            "             Z     "
        ).map { Array($0) }
        var terrain = Grid(pixelValues: pixelValues)
        terrain.render()
        
        var map = PortalMap(terrain: terrain)
        print(map)

        print("Solution")
        XCTAssertEqual(map.distanceFromAAToZZ, 23)

        pixelValues = Array(arrayLiteral:
            "                   A               ",
            "                   A               ",
            "  #################.#############  ",
            "  #.#...#...................#.#.#  ",
            "  #.#.#.###.###.###.#########.#.#  ",
            "  #.#.#.......#...#.....#.#.#...#  ",
            "  #.#########.###.#####.#.#.###.#  ",
            "  #.............#.#.....#.......#  ",
            "  ###.###########.###.#####.#.#.#  ",
            "  #.....#        A   C    #.#.#.#  ",
            "  #######        S   P    #####.#  ",
            "  #.#...#                 #......VT",
            "  #.#.#.#                 #.#####  ",
            "  #...#.#               YN....#.#  ",
            "  #.###.#                 #####.#  ",
            "DI....#.#                 #.....#  ",
            "  #####.#                 #.###.#  ",
            "ZZ......#               QG....#..AS",
            "  ###.###                 #######  ",
            "JO..#.#.#                 #.....#  ",
            "  #.#.#.#                 ###.#.#  ",
            "  #...#..DI             BU....#..LF",
            "  #####.#                 #.#####  ",
            "YN......#               VT..#....QG",
            "  #.###.#                 #.###.#  ",
            "  #.#...#                 #.....#  ",
            "  ###.###    J L     J    #.#.###  ",
            "  #.....#    O F     P    #.#...#  ",
            "  #.###.#####.#.#####.#####.###.#  ",
            "  #...#.#.#...#.....#.....#.#...#  ",
            "  #.#####.###.###.#.#.#########.#  ",
            "  #...#.#.....#...#.#.#.#.....#.#  ",
            "  #.###.#####.###.###.#.#.#######  ",
            "  #.#.........#...#.............#  ",
            "  #########.###.###.#############  ",
            "           B   J   C               ",
            "           U   P   P               "
        ).map { Array($0) }
        terrain = Grid(pixelValues: pixelValues)
        terrain.render()
        
        map = PortalMap(terrain: terrain)
        print(map)

        print("Solution")
        XCTAssertEqual(map.distanceFromAAToZZ, 58)
    }
    
    func test_solutions() {
        guard _enableAllTests else { return }

        let terrain = _makeTerrain()
        terrain.render()
        
        let map = PortalMap(terrain: terrain)
        print(map)

        print("Solution")
        XCTAssertEqual(map.distanceFromAAToZZ, 628)
    }
    
}


// MARK: - Private Terrain Implementation
private func _makeTerrain() -> Grid {
    let pixelValues = try! TestHarnessInput("input20.txt").map({ Array($0) })
    return Grid(pixelValues: pixelValues, backgroundValue: _backgroundValue)
}

private typealias PortalPositions = [Portal.Name: Set<Position>]

private extension Grid {
    
    func findPortals() -> PortalPositions {
        guard gridWidth >= 5 else { return [:] }
        guard gridHeight >= 5 else { return [:] }
    
        var result = PortalPositions()

        for x in 2 ..< (gridWidth - 2) {
            for y in 2 ..< (gridHeight - 2) {
                let newPosition = Position(x, y)
                
                if let portal = portal(at: newPosition) {
                    let previousPositions = result[portal] ?? Set<Position>()
                    result[portal] = previousPositions.union([newPosition])
                }
            }
        }

        return result
    }
    
    func portal(at position: Position) -> Portal.Name? {
        guard node(atGridPosition: position)?.value == "." else { return nil }

        let positionFilter = [
            [Position(-2, 0), Position(-1, 0)], // above the dot
            [Position(1, 0), Position(2, 0)],   // below the dot
            [Position(0, -2), Position(0, -1)], // left of the dot
            [Position(0, 1), Position(0, 2)]    // right of the dot
        ]
            
        let positions = positionFilter.map { $0.map { position &+ $0 } }
            
        // Avoid strange compile error.
        let _self = self
        
        let portalCandidates = positions
            .map { $0.compactMap { _self.node(atGridPosition: $0 )?.value } }
            .map { String($0) }

        return portalCandidates.first {
            $0.count == 2 && $0.allSatisfy { ("A"..."Z").contains($0) }
        }
    }
    
}

func _minimumDistanceBetween(_ lhs: Set<Position>, _ rhs: Set<Position>) -> Float? {
    guard !lhs.isEmpty && !rhs.isEmpty else { return nil }
    
    var result = Float.greatestFiniteMagnitude
    
    for lhsPosition in lhs {
        for rhsPosition in rhs {
            result = min(result, (lhsPosition &- rhsPosition).length)
        }
    }
    
    return result
}


// MARK: - Private Portal Implementation
private typealias PortalMap = GKGraph
private typealias PortalData = [Portal.Name: Portal]

private extension PortalData {
    mutating func portal(named name: Portal.Name, positions: PortalPositions) -> Portal {
        guard let portal = self[name] else {
            let newPortal = Portal(name: name, positions: positions)
            self[name] = newPortal
            return newPortal
        }
        return portal
    }
}

private extension PortalMap {
    
    var distanceFromAAToZZ: Int? {
        guard
            let start = portal(named: "AA"),
            let end = portal(named: "ZZ")
        else { return nil }
        
        let path = findPath(from: start, to: end).compactMap { $0 as? Portal }
        guard path.count > 1 else { return nil }
        
        return zip(
            path.prefix(path.count - 1), path.suffix(path.count - 1)
        ).map { (source, destination) in
            let distance = Int(source.cost(to: destination))
            print("\(source.name) to \(destination.name): \(distance)")
            return distance
        }.reduce(0, +)
    }
    
    convenience init(terrain: Grid) {
        let portalLocations = terrain.findPortals()
        
        // Don't traverse the characters of the portal names.
        // Instead, remove them from the grid.
        terrain.filter { $0 == "." }
        
        var data = PortalData()
        
        for (sourceName, sourcePositions) in portalLocations {
            let source = data.portal(named: sourceName, positions: portalLocations)
            
            for sourcePosition in sourcePositions {
                let _ = terrain.span(from: sourcePosition) { pixel in
                    let destinationPosition = pixel.gridPosition
                    assert(sourcePosition != destinationPosition)
                    
                    let _destinationName = portalLocations.filter {
                        $0.value.contains(destinationPosition)
                    }.first?.key
                    
                    if let destinationName = _destinationName, destinationName != sourceName {
                        let destination = data.portal(named: destinationName, positions: portalLocations)
                        
                        if
                            !source.connectedPortals.contains(destination),
                            let _distance = terrain.distance(from: sourcePosition, to: destinationPosition) {

                            let distance = sourceName == "AA" || destinationName == "AA" ?
                                _distance : _distance + 1
                            source.connect(to: destination, distance: distance)
                        }
                    }
                    
                    return true
                }
            }
        }
        
        self.init(Array(data.values))
    }
    
    func portal(named name: Portal.Name) -> Portal? {
        guard let nodes = nodes else { return nil }
        return nodes.compactMap { $0 as? Portal }.first { $0.name == name }
    }
    
}

extension PortalMap {
    open override var description: String {
        guard
            let portals = nodes?.compactMap({ $0 as? Portal }),
            !portals.isEmpty
        else { return super.description }
        return portals.reduce("") { $0 + String(describing: $1) + "\n" }
    }
}

// TODO: Share generic implementation with Pixel.
//       Perhaps a Value template argument.
private final class Portal: GKGraphNode {
    
    typealias Name = String
    var name: Name
    
    var connectedPortals: [Portal] {
        connectedNodes.compactMap { $0 as? Portal }
    }
    
    // MARK: Factory
    init(name: Name, positions: PortalPositions) {
        self.name = name
        estimatedDistanceTo = positions.estimatedDistances(from: name)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func connect(to portal: Portal, distance: Int) {
        super.addConnections(to: [portal], bidirectional: true)
        distanceTo[portal] = distance
        portal.distanceTo[self] = distance
    }
    
    // MARK: Span
    override func cost(to node: GKGraphNode) -> Float {
        guard let distance = distanceTo[node] else {
            return super.cost(to: node)
        }
        return Float(distance)
    }

    override func estimatedCost(to node: GKGraphNode) -> Float {
        guard let destination = (node as? Portal)?.name else {
            return .greatestFiniteMagnitude
        }
        return estimatedDistanceTo[destination] ?? .greatestFiniteMagnitude
    }
    
    // MARK: Private
    private var distanceTo = [GKGraphNode: Int]()
    private var estimatedDistanceTo = [Name: Float]()
    
}

extension Portal {
    override var description: String {
        let prefix = "Portal(\"\(name)\")"
        return connectedPortals.reduce(prefix) {
            guard let distance = distanceTo[$1] else { return $0 }
            return $0 + "\n    \(distance) steps to Portal(\"\($1.name)\")"
        }
    }
}

private extension PortalPositions {
    func estimatedDistances(from source: Portal.Name) -> [Portal.Name: Float] {
        guard let localPositions = self[source] else { return [:] }
        
        var result = [Portal.Name: Float]()
        
        for destination in Set(keys).subtracting([source]) {
            guard
                let remotePositions = self[destination],
                let distance = _minimumDistanceBetween(localPositions, remotePositions)
            else { continue }
            
            result[destination] = distance
        }
        
        return result
    }
}

