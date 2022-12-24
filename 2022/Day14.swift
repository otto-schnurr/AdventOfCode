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

func positions(for segment: Segment) -> [Position] {
    if segment.from.x == segment.to.x {
        let range = segment.from.y < segment.to.y ?
            (segment.from.y ... segment.to.y) :
            (segment.to.y ... segment.from.y)
        return range.map { Position(segment.from.x, $0) }
    } else if segment.from.y == segment.to.y {
        let range = segment.from.x < segment.to.x ?
            (segment.from.x ... segment.to.x) :
            (segment.to.x ... segment.from.x)
        return range.map { Position($0, segment.from.y) }
    } else {
        return [ ]
    }
}

struct Grid {
    private(set) var positions: Set<Position>
    
    init(segments: [Segment]) {
        positions = Set(segments.map(positions(for:)).joined())
    }
}

let segments = StandardInput().map { line in
    let words = Array(line.split(separator: " "))
    let positions = stride(from: 0, through: words.count, by: 2).map {
        let numbers = words[$0].split(separator: ",").map { Int($0)! }
        return Position(numbers[0], numbers[1])
    }
    return zip(positions, positions[1...])
        .map { from, to in Segment(from, to) }
}
var grid = Grid(segments: Array(segments.joined()))
print(grid.positions)
