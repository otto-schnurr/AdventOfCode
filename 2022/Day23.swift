#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/22
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

typealias Position = SIMD2<Int>

enum Direction: Int {
    static let count = 4
    case north, east, south, west
    
    func adjacentPositions(from position: Position) -> Set<Position> {
        let result: [(x: Int, y: Int)]

        switch self {
        case .north:
            result = (position.x - 1 ... position.x + 1)
                .map { ($0, position.y - 1) }
        case .south:
            result = (position.x - 1 ... position.x + 1)
                .map { ($0, position.y + 1) }
        case .west:
            result = (position.y - 1 ... position.y + 1)
                .map { (position.x - 1, $0) }
        case .east:
            result = (position.y - 1 ... position.y + 1)
                .map { (position.x + 1, $0) }
        }
        
        return Set(result.map { Position($0.x, $0.y) })
    }
}

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
    
    mutating func apply(_ directions: [Direction]) {
        // implement me
    }
}

var grid = Grid(lines: Array(StandardInput()))

for roundIndex in 0 ..< 10 {
    let directions = (0 ..< Direction.count).map {
        Direction(rawValue: (roundIndex + $0) % Direction.count)!
    }
    grid.apply(directions)
}

print(grid.positions)
