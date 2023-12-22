#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2023/day/17
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2023 Otto Schnurr

import SwiftPriorityQueue // https://github.com/davecom/SwiftPriorityQueue

// MARK: Types
typealias Position = SIMD2<Int>
typealias Cost = Int
typealias Grid = [Position: Cost]

enum Direction: CaseIterable {
    
    case up, down, left, right
    
    static let all = Set(Self.allCases)
    
    var offset: Position {
        switch self {
        case .up:    return Position(0, -1)
        case .down:  return Position(0, +1)
        case .left:  return Position(-1, 0)
        case .right: return Position(+1, 0)
        }
    }
    
    var successors: Set<Self> { Self.all.subtracting(Set([ self.reversed ])) }
    
    var reversed: Self {
        switch self {
        case .up:    return .down
        case .down:  return .up
        case .left:  return .right
        case .right: return .left
        }
    }
    
}

struct Traversal: Hashable {
    
    let position: Position
    let direction: Direction
    let tailLength: Int

    static func == (lhs: Traversal, rhs: Traversal) -> Bool {
        lhs.position == rhs.position &&
        lhs.direction == rhs.direction &&
        lhs.tailLength == rhs.tailLength
    }
    
    init(_ position: Position, _ direction: Direction, _ tailLength: Int = 0) {
        self.position = position
        self.direction = direction
        self.tailLength = tailLength
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(direction)
        hasher.combine(tailLength)
    }
    
    func makeNextTraversal(_ nextPosition: Position, _ nextDirection: Direction) -> Self {
        let nextTailLength = nextDirection == direction ? tailLength + 1 : 0
        return Traversal(nextPosition, nextDirection, nextTailLength)
    }
    
    func successorsWithTailLength(in range: Range<Int>) -> Set<Direction> {
        let notAllowed = range.contains(tailLength) ? [ ] : [ direction ]
        return direction.successors.subtracting(Set(notAllowed))
    }
    
}

struct State: Hashable, Comparable {
    
    let traversal: Traversal
    let cost: Cost
    let estimatedRemainingCost: Cost
    
    static func < (lhs: State, rhs: State) -> Bool {
        lhs.cost + lhs.estimatedRemainingCost < rhs.cost + rhs.estimatedRemainingCost
    }

    static func == (lhs: State, rhs: State) -> Bool {
        lhs.traversal == rhs.traversal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(traversal)
    }
    
    init(
        traversal: Traversal,
        cost: Cost = .zero,
        estimatedRemainingCost: Cost = .zero
    )
    {
        self.traversal = traversal
        self.cost = cost
        self.estimatedRemainingCost = estimatedRemainingCost
    }
    
}

// MARK: Data
struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let lines = Array(StandardInput())
let gridSize = (width: lines[0].count, height: lines.count)
let gridCost = parseGrid(from: lines)

let part1 = findPath(
    across: gridCost,
    from: State(traversal: Traversal(.zero, .right)),
    to: Position(gridSize.width - 1, gridSize.height - 1),
    allowedTailLengths: 0 ..< 2
)

print("part 1 : \(part1)")

// MARK: Functions
func parseGrid(from lines: [String]) -> [Position: Cost] {
    var grid: Grid = [:]
    
    for (y, line) in lines.enumerated() {
        for (x, character) in line.enumerated() {
            grid[Position(x, y)] = Int(String(character))!
        }
    }
    
    return grid
}

//
///// A-Star
//
// reference: https://github.com/davecom/SwiftPriorityQueue/blob/master/SwiftPriorityQueue/astar.swift
//
func estimatedCost(from start: Position, to end: Position) -> Cost {
    let diff = end &- start
    return diff.indices.reduce(into: 0) { $0 += abs(diff[$1]) }
}

func findPath(
    across grid: Grid,
    from startingState: State,
    to target: Position,
    allowedTailLengths: Range<Int>
) -> Cost {
    var accumulatedCostFor: [Traversal: Cost] = [:]
    var frontier = PriorityQueue(ascending: true, startingValues: [ startingState ])
    
    while let currentState = frontier.pop() {
        let currentTraversal = currentState.traversal
        guard currentTraversal.position != target else { return currentState.cost }
        
        let successors = currentTraversal.successorsWithTailLength(in: allowedTailLengths)
        
        for nextDirection in successors {
            let currentTraversal = currentState.traversal
            let nextPosition = currentTraversal.position &+ nextDirection.offset
            let nextTraversal = currentTraversal.makeNextTraversal(nextPosition, nextDirection)
            guard let gridCost = grid[nextPosition] else { continue }
            
            let newCost = currentState.cost + gridCost
            let previousCost = accumulatedCostFor[nextTraversal, default: Cost.max]
            
            if newCost < previousCost {
                accumulatedCostFor[nextTraversal] = newCost

                let nextState = State(
                    traversal: nextTraversal,
                    cost: newCost,
                    estimatedRemainingCost: estimatedCost(from: nextPosition, to: target)
                )
                frontier.push(nextState)
            }
        }
    }

    return 0
}
