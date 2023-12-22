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
    
    var successors: Set<Self> {
        var result = Self.all
        result.remove(self.reversed)
        return result
    }
    
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
    
    static func == (lhs: Traversal, rhs: Traversal) -> Bool {
        lhs.position == rhs.position && lhs.direction == rhs.direction
    }
    
    init(_ position: Position, _ direction: Direction) {
        self.position = position
        self.direction = direction
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(direction)
    }
    
}

struct State: Hashable, Comparable {
    
    let traversal: Traversal
    let history: [Direction]
    let cost: Cost
    let estimatedRemainingCost: Cost
    
    var successors: Set<Direction> {
        let mustTurn = history == [ traversal.direction, traversal.direction ]

        var result = traversal.direction.successors
        if mustTurn { result.remove(traversal.direction) }
        
        return result
    }
    
    var nextHistory: [Direction] {
        let newHistory = [traversal.direction] + history
        return Array(newHistory.prefix(2))
    }
    
    static func < (lhs: State, rhs: State) -> Bool {
        lhs.cost + lhs.estimatedRemainingCost < rhs.cost + rhs.estimatedRemainingCost
    }

    static func == (lhs: State, rhs: State) -> Bool {
        lhs.traversal == rhs.traversal && lhs.history == rhs.history
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(traversal)
        hasher.combine(history)
    }
    
    init(
        traversal: Traversal,
        history: [Direction] = [ ],
        cost: Cost = .zero,
        estimatedRemainingCost: Cost = .zero
    )
    {
        self.traversal = traversal
        self.history = history
        self.cost = cost
        self.estimatedRemainingCost = estimatedRemainingCost
    }
    
    func makeNextState(
        traversal: Traversal, cost: Cost, estimatedRemainingCost: Cost
    ) -> Self {
        let nextHistory = [ self.traversal.direction ] + history
        return State(
            traversal: traversal,
            history: Array(nextHistory.prefix(2)),
            cost: cost,
            estimatedRemainingCost: estimatedRemainingCost
        )
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
    from: [
        State(traversal: Traversal(.zero, .right)),
        State(traversal: Traversal(.zero, .down)),
    ],
    to: Position(gridSize.width - 1, gridSize.height - 1)
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

// A-Star
func estimatedCost(from start: Position, to end: Position) -> Cost {
    let diff = end &- start
    return diff.indices.reduce(into: 0) { $0 += abs(diff[$1]) }
}

func findPath(
    across grid: Grid,
    from startingStates: [State],
    to target: Position
) -> Cost {
    var accumulatedCostFor: [State: Cost] = [:]
    var frontier = PriorityQueue(ascending: true, startingValues: startingStates)
    
    while let currentState = frontier.pop() {
        if currentState.traversal.position == target {
            return currentState.cost
        }
        
        for nextDirection in currentState.successors {
            let nextPosition = currentState.traversal.position &+ nextDirection.offset
            guard let gridCost = grid[nextPosition] else { continue }
            
            let nextTraversal = Traversal(nextPosition, nextDirection)
            let newCost = currentState.cost + gridCost
            let nextState = currentState.makeNextState(
                traversal: nextTraversal,
                cost: newCost,
                estimatedRemainingCost: estimatedCost(from: nextPosition, to: target)
            )

            let previousCost = accumulatedCostFor[nextState, default: Cost.max]

            if newCost < previousCost {
                accumulatedCostFor[nextState] = newCost
                frontier.push(nextState)
            }
        }
    }

    return 0
}
