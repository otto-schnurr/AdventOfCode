//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day17.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/17
//  Created by Otto Schnurr on 12/18/2020.
//

import XCTest

final class Day17: XCTestCase {

    func test_examples() {
        let lines = """
        .#.
        ..#
        ###
        """.components(separatedBy: .newlines)
        var grid = Grid(from: lines)
        
        for _ in 1...6 { grid = _update(grid) }
        XCTAssertEqual(grid.count, 112)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
private typealias Position = SIMD3<Int>
private typealias Grid = Set<Position>

private let _adjacentOffsets: [Position] = {
    let range = -1 ... +1
    var result = [Position]()
    
    for x in range {
        for y in range {
            for z in range {
                let position = Position(x, y, z)
                if position != .zero { result.append(position) }
            }
        }
    }
    
    return result
}()

private extension Set where Element == Position {
    
    init<Lines>(from lines: Lines) where Lines: Sequence, Lines.Element == String {
        var result = Set<Position>()
        
        for (y, row) in lines.enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.insert(Position(x, y, 0))
            }
        }

        self = result
    }

}

private func _update(_ grid: Grid) -> Grid {
    var adjacentPositions = Grid()
    var result = Grid()

    // Collate active neighbors around active positions.
    // Also collate positions adjacent to active positions.
    for position in grid {
        var neigborCount = 0
        
        for offset in _adjacentOffsets {
            let adjacentPosition = position &+ offset
            adjacentPositions.insert(adjacentPosition)
            
            if neigborCount < 4 {
                neigborCount += grid.contains(adjacentPosition) ? 1 : 0
            }
        }
        
        if (2...3).contains(neigborCount) {
            result.insert(position)
        }
    }
    
    // Don't include previously active in adjacent.
    adjacentPositions.subtract(grid)
    
    // Collate active neighbors around empty adjacent positions.
    for position in adjacentPositions {
        var neigborCount = 0
        
        for offset in _adjacentOffsets {
            let adjacentPosition = position &+ offset
            
            if neigborCount < 4 {
                neigborCount += grid.contains(adjacentPosition) ? 1 : 0
            }
        }
        
        if neigborCount == 3 {
            result.insert(position)
        }
    }
    
    return result
}
