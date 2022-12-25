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

func allPositions(for segment: Segment) -> [Position] {
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
        positions = Set(segments.map(allPositions(for:)).joined())
    }
    
    mutating func addFloor() {
        let floorDepth = bottom + 2
        let floorRadius = floorDepth
        let floorSegment = (
            from: Position(500 - floorRadius, floorDepth),
            to: Position(500 + floorRadius, floorDepth)
        )
        positions.formUnion(allPositions(for: floorSegment))
    }
    
    mutating func addedSandComesToRestAt() -> Position? {
        let bottom = bottom
        var currentPosition = Position(500, 0)
        var nextPosition = incrementSand(at: currentPosition)
        
        while currentPosition != nextPosition {
            currentPosition = nextPosition
            guard currentPosition.y < bottom else { return nil }
            nextPosition = incrementSand(at: currentPosition)
        }

        positions.insert(currentPosition)
        return currentPosition
    }
    
    // MARK: Private
    private var bottom: Int { return positions.map { $0.y }.max()! }
    
    private func incrementSand(at position: Position) -> Position {
        let candidates =
            [ 0, -1, +1 ].map { Position(position.x + $0, position.y + 1) }
        return candidates.first { !positions.contains($0) } ?? position
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
var grid1 = Grid(segments: Array(segments.joined()))
var grid2 = grid1
grid2.addFloor()

var sandCount = 0
while grid1.addedSandComesToRestAt() != nil { sandCount += 1 }
print("part 1 : \(sandCount)")

sandCount = 0
while let sandPosition = grid2.addedSandComesToRestAt() {
    sandCount += 1
    guard sandPosition.y > 0 else { break }
}
print("part 2 : \(sandCount)")
