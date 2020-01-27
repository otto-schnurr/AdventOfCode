//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day20.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/20
//  Created by Otto Schnurr on 1/23/2020.
//

import XCTest
import AdventOfCode

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false
private let _backgroundValue = Pixel.Value("#")

final class Day20: XCTestCase {
    
    func test_examples() {
        let pixelValues = Array(arrayLiteral:
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
        let terrain = Grid(pixelValues: pixelValues)
        let portalAt = terrain.findPortals()
        print(portalAt)
    }
    
    func test_solutions() {
        guard _enableAllTests else { return }
        let map = _makeMap()
        XCTAssertEqual(map.gridWidth, 127)
        XCTAssertEqual(map.gridHeight, 129)
    }
    
}


// MARK: - Private Terrain Implementation
private func _makeMap() -> Grid {
    let pixelValues = try! TestHarnessInput("input20.txt").map({ Array($0) })
    return Grid(pixelValues: pixelValues, backgroundValue: _backgroundValue)
}

private typealias PortalName = String

private extension Grid {
    
    func findPortals() -> [PortalName: Set<Position>] {
        guard gridWidth >= 5 else { return [:] }
        guard gridHeight >= 5 else { return [:] }
    
        var result = [PortalName: Set<Position>]()

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
    
    func portal(at position: Position) -> PortalName? {
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
