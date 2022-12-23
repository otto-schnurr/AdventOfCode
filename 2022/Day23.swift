#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/22
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}
let lines = Array(StandardInput())

typealias Position = SIMD2<Int>

struct Grid {
    private(set) var positions: Set<Position>
    
    init(lines: [String]) {
        let positions = lines.enumerated()
            .map { yPosition, line in
                line.enumerated().filter { xPosition, character in
                    character == "#"
                }.map { xPosition, _ in
                    Position(yPosition, xPosition)
                }
            }.joined()
        
        self.positions = Set(positions)
    }
}
let grid = Grid(lines: lines)

print(grid.positions)
