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
    
    func intersects(_ rhs: Grid) -> Bool {
        guard
            horizontalBoundary.overlaps(rhs.horizontalBoundary) ||
            verticalBoundary.overlaps(rhs.verticalBoundary)
        else { return false }
        
        return positions.isDisjoint(with: rhs.positions)
    }
    
    func offset(by offset: Position) -> Grid {
        return Grid(
            horizontalBoundary: horizontalBoundary + offset.x,
            verticalBoundary: verticalBoundary + offset.y,
            positions: Set(positions.map { $0 &+ offset })
        )
    }
    
    mutating func add(_ grid: Grid) {
        horizontalBoundary =
            horizontalBoundary.formUnion(grid.horizontalBoundary)
        verticalBoundary =
            verticalBoundary.formUnion(grid.verticalBoundary)
        positions.formUnion(grid.positions)
    }
    
    private var positions: Set<Position>
}

extension ClosedRange where Bound: AdditiveArithmetic {
    static func +(lhs: ClosedRange, offset: Bound) -> ClosedRange {
        return lhs.lowerBound + offset ... lhs.upperBound + offset
    }
    
    func formUnion(_ rhs: ClosedRange<Bound>) -> ClosedRange<Bound> {
        let newLower = Swift.min(lowerBound, rhs.lowerBound)
        let newUpper = Swift.max(upperBound, rhs.upperBound)
        return newLower ... newUpper
    }
    
    func contains(_ rhs: ClosedRange<Bound>) -> Bool {
        return rhs.clamped(to: self) == rhs
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

func offset(for direction: Character) -> Position {
    switch direction {
        case "<": return Position(-1, 0)
        case ">": return Position(+1, 0)
        default:  return Position()
    }
}

var rockCount = 0
var rock: Grid?
var rockPosition = Position()
var chamber = Grid(horizontalBoundary: 0...6, verticalBoundary: 0...0, positions: [ ])

readLine()!.forEach { direction in
    if rock == nil {
        rockPosition = Position(2, chamber.verticalBoundary.upperBound + 3)
        rock = rockTypes[rockCount % rockTypes.count].offset(by: rockPosition)
        rockCount += 1
    }
    
    // apply jet
    var updatedRock = rock!.offset(by: offset(for: direction))
    rock = chamber.horizontalBoundary.contains(updatedRock.horizontalBoundary) ?
    updatedRock : rock
    
    // apply gravity
    updatedRock = rock!.offset(by: Position(0, 1))

    if chamber.intersects(updatedRock) {
        chamber.add(rock!)
        rock = nil
    } else {
        rock = updatedRock
    }
}

print("part 1: \(chamber.verticalBoundary.upperBound)")
