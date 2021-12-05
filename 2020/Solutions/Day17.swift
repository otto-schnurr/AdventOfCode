//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day17.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/17
//  Created by Otto Schnurr on 12/18/2020.
//

import XCTest

final class Day17: XCTestCase {

    func test_example_part1() {
        let lines = """
        .#.
        ..#
        ###
        """.components(separatedBy: .newlines)

        var grid = Grid3D(from: lines)
        for _ in 1...6 { grid = _update(grid, offsets: _adjacentOffsets3D) }
        XCTAssertEqual(grid.count, 112)
    }
    
    func TOO_SLOW_test_example_part2() {
        let lines = """
        .#.
        ..#
        ###
        """.components(separatedBy: .newlines)

        var grid = Grid4D(from: lines)
        for _ in 1...6 { grid = _update(grid, offsets: _adjacentOffsets4D) }
        XCTAssertEqual(grid.count, 848)
    }

    func test_solution_part1() {
        let lines = """
        #.#.##.#
        #.####.#
        ...##...
        #####.##
        #....###
        ##..##..
        #..####.
        #...#.#.
        """.components(separatedBy: .newlines)
        
        var grid = Grid3D(from: lines)
        for _ in 1...6 { grid = _update(grid, offsets: _adjacentOffsets3D) }
        XCTAssertEqual(grid.count, 380)
    }
    
    func TOO_SLOW_test_solution_part2() {
        let lines = """
        #.#.##.#
        #.####.#
        ...##...
        #####.##
        #....###
        ##..##..
        #..####.
        #...#.#.
        """.components(separatedBy: .newlines)
        
        var grid = Grid4D(from: lines)
        for _ in 1...6 { grid = _update(grid, offsets: _adjacentOffsets4D) }
        XCTAssertEqual(grid.count, 2_332)
    }
    
}


// MARK: - Private
private typealias Position3D = SIMD3<Int>
private typealias Grid3D = Set<Position3D>

private typealias Position4D = SIMD4<Int>
private typealias Grid4D = Set<Position4D>

private let _adjacentOffsets3D: [Position3D] = {
    let range = -1 ... +1
    var result = [Position3D]()
    
    for x in range {
        for y in range {
            for z in range {
                let position = Position3D(x, y, z)
                if position != .zero { result.append(position) }
            }
        }
    }
    
    return result
}()

private let _adjacentOffsets4D: [Position4D] = {
    let range = -1 ... +1
    var result = [Position4D]()
    
    for x in range {
        for y in range {
            for z in range {
                for w in range {
                    let position = Position4D(x, y, z, w)
                    if position != .zero { result.append(position) }
                }
            }
        }
    }
    
    return result
}()

private extension Set where Element == Position3D {
    
    init<Lines>(from lines: Lines) where Lines: Sequence, Lines.Element == String {
        var result = Grid3D()
        
        for (y, row) in lines.enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.insert(Position3D(x, y, 0))
            }
        }

        self = result
    }

}

private extension Set where Element == Position4D {
    
    init<Lines>(from lines: Lines) where Lines: Sequence, Lines.Element == String {
        var result = Grid4D()
        
        for (y, row) in lines.enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.insert(Position4D(x, y, 0, 0))
            }
        }

        self = result
    }

}

private func _update<P: SIMD>(
    _ grid: Set<P>, offsets: [P]
) -> Set<P> where P.Scalar: FixedWidthInteger {
    var adjacentPositions = Set<P>()
    var result = Set<P>()

    // Collate active neighbors around active positions.
    // Also collate positions adjacent to active positions.
    for position in grid {
        var neigborCount = 0
        
        for offset in offsets {
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
        
        for offset in offsets {
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
