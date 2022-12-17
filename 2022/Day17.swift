#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/17
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

typealias Position = SIMD2<Int>

struct Grid {
    private (set) var horizontalBoundary: ClosedRange<Int>
    private (set) var verticalBoundary: ClosedRange<Int>
    
    init(
        horizontalBoundary: ClosedRange<Int>,
        verticalBoundary: ClosedRange<Int>,
        positions: Set<Position>
    ) {
        self.horizontalBoundary = horizontalBoundary
        self.verticalBoundary = verticalBoundary
        self.positions = positions
    }
    
    init(positions: Set<Position>) {
        let xValues = positions.map(\.x)
        let yValues = positions.map(\.y)

        horizontalBoundary = xValues.min()! ... xValues.max()!
        verticalBoundary = yValues.min()! ... yValues.max()!
        self.positions = positions
    }
    
    func moved(to position: Position) -> Grid {
        return Grid(
            horizontalBoundary: horizontalBoundary + position.x,
            verticalBoundary: verticalBoundary+position.y,
            positions: Set(positions.map { $0 &+ position })
        )
    }
    
    mutating func add(_ grid: Grid) {
        horizontalBoundary = horizontalBoundary.formUnion(grid.horizontalBoundary)
        verticalBoundary = verticalBoundary.formUnion(grid.verticalBoundary)
        positions.formUnion(grid.positions)
    }
    
    private var positions: Set<Position>
}

extension ClosedRange where Bound: AdditiveArithmetic {
    static func +(lhs: ClosedRange, rhs: Bound) -> ClosedRange {
        return lhs.lowerBound + rhs ... lhs.upperBound + rhs
    }
    
    func formUnion(_ rhs: ClosedRange<Bound>) -> ClosedRange<Bound> {
        let newLower = Swift.min(lowerBound, rhs.lowerBound)
        let newUpper = Swift.max(upperBound, rhs.upperBound)
        return newLower ... newUpper
    }
}

let rockTypes = [
    Grid(positions: [
        Position(0, 0), Position(1, 0), Position(2, 0), Position(3, 0)
    ]),
    Grid(positions: [
        Position(1, 0),
        Position(0, 1), Position(1, 1), Position(2, 1),
        Position(1, 2)
    ]),
    Grid(positions: [
        Position(0, 0), Position(1, 0),
        Position(2, 0), Position(2, 1), Position(2, 2)
    ]),
    Grid(positions: [
        Position(0, 0), Position(0, 1), Position(0, 2), Position(0, 3)
    ]),
    Grid(positions: [
        Position(0, 0), Position(1, 0),
        Position(0, 2), Position(1, 2)
    ]),
]

var rockIndex = 0
var chamber = Grid(horizontalBoundary: 0...6, verticalBoundary: 0...0, positions: [ ])

readLine()!.forEach { direction in
    print(direction)
}
