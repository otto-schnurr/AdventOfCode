#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2024/day/4
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

typealias Position = SIMD2<Int>
typealias Grid = [Position: Character]

let directions = [
    Position(0, 1),  Position(1, 1),   Position(1, 0),  Position(1, -1),
    Position(0, -1), Position(-1, -1), Position(-1, 0), Position(-1, 1),
]
let kernel = directions.map { direction in (0...3).map { $0 &* direction } }

let lines = Array(StandardInput())
let mapSize = (width: lines[0].count, height: lines.count)
let grid = Grid(lines: lines)
let wordStarts = grid.filter { $0.value == "X" }.map { $0.key }

let words = wordStarts.flatMap { origin in
    kernel.map { $0.map { origin &+ $0 } }
}.map { grid.word(for: $0) }

print("part 1 : \(words.filter { $0 == "XMAS" }.count)")

extension Grid {
    init(lines: [String]) {
        var result: Grid = [:]

        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                result[Position(x, y)] = character
            }
        }

        self = result
    }

    func word(for positions: [Position]) -> String {
        return String(positions.compactMap { self[$0] })
    }
}
