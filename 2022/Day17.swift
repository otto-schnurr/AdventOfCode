#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/17
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

typealias Position = SIMD2<Int>
typealias Boundary = ClosedRange<Int>

struct Grid {
    var top: Int { return positions.map { $0.y }.max() ?? 0 }
    
    init(positions: Set<Position>) {
        self.positions = positions
        (hBoundary, vBoundary) = Grid.boundaries(for: positions)
    }
 
    init(positions: [(x: Int, y: Int)]) {
        self.positions = Set(positions.map { Position($0.x, $0.y) })
        (hBoundary, vBoundary) = Grid.boundaries(for: self.positions)
    }
    
    func intersects(_ rhs: Grid) -> Bool {
        guard
            hBoundary.overlaps(rhs.hBoundary) ||
            vBoundary.overlaps(rhs.vBoundary)
        else { return false}
        
        return !positions.isDisjoint(with: rhs.positions)
    }
    
    func xValues(areContainedBy horizontalBoundary: ClosedRange<Int>) -> Bool {
        return positions.allSatisfy { horizontalBoundary.contains($0.x) }
    }
    
    func offset(by offset: Position) -> Grid {
        return Grid(positions: Set(positions.map { $0 &+ offset }))
    }
    
    mutating func add(_ grid: Grid) {
        positions.formUnion(grid.positions)
        hBoundary = hBoundary.formUnion(grid.hBoundary)
        vBoundary = vBoundary.formUnion(grid.vBoundary)
    }
    
    // MARK: Private
    private static func boundaries(
        for positions: Set<Position>
    ) -> (hBoundary: Boundary, vBoundary: Boundary) {
        let xValues = positions.map { $0.x }
        let yValues = positions.map { $0.y }
        
        return (
            hBoundary: xValues.min()! ... xValues.max()!,
            vBoundary: yValues.min()! ... yValues.max()!
        )
    }
    
    private var positions: Set<Position>
    private var hBoundary: Boundary
    private var vBoundary: Boundary
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
    Grid(positions: [ (0, 0), (1, 0), (2, 0), (3, 0) ]),
    Grid(positions: [ (1, 0), (0, 1), (1, 1), (2, 1), (1, 2) ]),
    Grid(positions: [ (0, 0), (1, 0), (2, 0), (2, 1), (2, 2) ]),
    Grid(positions: [ (0, 0), (0, 1), (0, 2), (0, 3) ]),
    Grid(positions: [ (0, 0), (1, 0), (0, 1), (1, 1) ])
]

func offset(for direction: Character) -> Position {
    switch direction {
        case "<": return Position(-1, 0)
        case ">": return Position(+1, 0)
        default:  return Position()
    }
}

let chamberWidth = 0 ... 6

var rockCount = 0
var rock: Grid?
var rockPosition = Position()
var chamber = Grid(positions:
    [ (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0)  ]
)

for direction in readLine()!.cycled() {
    if rock == nil {
        rockPosition = Position(2, chamber.top + 4)
        rock = rockTypes[rockCount % rockTypes.count].offset(by: rockPosition)
        rockCount += 1
    }
    
    // apply jet
    let jetOffset = offset(for: direction)
    var updatedRock = rock!.offset(by: jetOffset)
    
    if updatedRock.xValues(areContainedBy: chamberWidth) &&
        !chamber.intersects(updatedRock) {
        rock = updatedRock
        rockPosition &+= jetOffset
    }
    
    // apply gravity
    let gravityOffset = Position(0, -1)
    updatedRock = rock!.offset(by: gravityOffset)

    if chamber.intersects(updatedRock) {
        chamber.add(rock!)
        rock = nil
        
        if rockCount >= 2022 { break }
    } else {
        rock = updatedRock
        rockPosition &+= gravityOffset
    }
}

print("part 1: \(chamber.top)")
