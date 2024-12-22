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
    Position(+1, +1), Position(+1, -1), Position(-1, +1), Position(-1, -1),
    Position(0, +1),  Position(+1, 0),  Position(0, -1),  Position(-1, 0)
]
let corners = directions.prefix(4)

let directionKernel = directions.map {
    direction in (0...3).map { $0 &* direction }
}
let cornerKernel = [
    [ corners[0], corners[1] ], [ corners[0], corners[2] ],
    [ corners[3], corners[1] ], [ corners[3], corners[2] ]
].map { cornerPair in
    cornerPair.flatMap { corner in
        (-1 ... +1).reversed().map { $0 &* corner }
    }
}

let lines = Array(StandardInput())
let mapSize = (width: lines[0].count, height: lines.count)
let grid = Grid(lines: lines)

let directionWords = grid.words(startingWith: "X", for: directionKernel)
print("part 1 : \(directionWords.filter { $0 == "XMAS" }.count)")

let cornerWords = grid.words(startingWith: "A", for: cornerKernel)
print("part 2 : \(cornerWords.filter { $0 == "MASMAS" }.count)")

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

    func words(
        startingWith firstCharacter: Character, for kernel: [[Position]]
    ) -> [String] {
        let wordStarts = self.filter {
            $0.value == firstCharacter
        }.map { $0.key }

        return wordStarts.flatMap { origin in
            kernel.map { $0.map { origin &+ $0 } }
        }.map { self.word(for: $0) }
    }
}
