#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/14
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

typealias Position = SIMD2<Int>
typealias Segment = (from: Position, to: Position)

struct Grid {
    private(set) var positions: Set<Position>
}

let segments = StandardInput().map { line in
    let words = Array(line.split(separator: " "))
    let positions = stride(from: 0, through: words.count, by: 2).map {
        let numbers = words[$0].split(separator: ",").map { Int($0)! }
        return Position(numbers[0], numbers[1])
    }
    return zip(positions, positions[1...]).map { from, to in Segment(from, to) }
}

print(segments)
