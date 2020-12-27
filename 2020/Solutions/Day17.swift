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
        let grid = Grid(from: lines)
        print(grid)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
private typealias Position = SIMD3<Int>
private typealias Grid = Set<Position>

private extension Position {
    var adjacentPositions: [Position] {
        // !!!: implement me
        return [ ]
    }
}

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
