//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day12.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/12
//  Created by Otto Schnurr on 12/12/2020.
//

import XCTest

final class Day12: XCTestCase {

    func test_examples() {
        let instructions = """
        F10
        N3
        F7
        R90
        F11
        """.components(separatedBy: .newlines).map { Instruction($0)! }
        var position = _run(instructions)
        XCTAssertEqual(abs(position.x) + abs(position.y), 25)
        
        position = _run(instructions, waypoint: Position(10, -1))
        XCTAssertEqual(abs(position.x) + abs(position.y), 286)
    }

    func test_solution() {
        let instructions = TestHarnessInput("input12.txt")!.map { Instruction($0)! }

        var position = _run(instructions)
        XCTAssertEqual(abs(position.x) + abs(position.y), 2_280)

        position = _run(instructions, waypoint: Position(10, -1))
        XCTAssertEqual(abs(position.x) + abs(position.y), 38_693)
    }
    
}


// MARK: - Private
private func _run(_ instructions: [Instruction]) -> Position {
    var position = Position.zero
    var direction = Direction.east
    instructions.forEach { $0.apply(to: &position, facing: &direction)}
    return position
}

private func _run(_ instructions: [Instruction], waypoint: Position) -> Position {
    var position = Position.zero
    var waypoint = waypoint
    instructions.forEach { $0.apply(to: &position, waypoint: &waypoint) }
    return position
}

private typealias Position = SIMD2<Int>

private extension Position {
    mutating func rotateLeft()  { self = Position(+y, -x) }
    mutating func rotateRight() { self = Position(-y, +x) }
}

private enum Direction: Character {
    
    case north = "N"
    case south = "S"
    case east = "E"
    case west = "W"
    
    func apply(value: Int, to position: inout Position) {
        switch self {
        case .north: position.y -= value
        case .south: position.y += value
        case .east: position.x += value
        case .west: position.x -= value
        }
    }
    
    mutating func turnLeft() {
        switch self {
        case .north: self = .west
        case .south: self = .east
        case .east:  self = .north
        case .west:  self = .south
        }
    }
    
    mutating func turnRight() {
        switch self {
        case .north: self = .east
        case .south: self = .west
        case .east:  self = .south
        case .west:  self = .north
        }

    }
    
}

private enum Movement: Character {

    case left = "L"
    case right = "R"
    case forward = "F"

    func apply(
        value: Int, to position: inout Position, facing direction: inout Direction
    ) {
        switch self {
        case .left:
            for _ in 1 ... (value / 90) { direction.turnLeft() }
        case .right:
            for _ in 1 ... (value / 90) { direction.turnRight() }
        case .forward:
            direction.apply(value: value, to: &position)
        }
    }
    
    func apply(
        value: Int, to position: inout Position, waypoint: inout Position
    ) {
        switch self {
        case .left:
            for _ in 1 ... (value / 90) { waypoint.rotateLeft() }
        case .right:
            for _ in 1 ... (value / 90) { waypoint.rotateRight() }
        case .forward:
            position &+= value &* waypoint
        }
    }
    
}

private enum Action {
    
    case direction(Direction)
    case movement(Movement)
    
    init?(_ character: Character) {
        if let direction = Direction(rawValue: character) {
            self = .direction(direction)
        } else if let movement = Movement(rawValue: character) {
            self = .movement(movement)
        } else {
            return nil
        }
    }
    
}

private struct Instruction {
    
    let action: Action
    let value: Int
    
    init?(_ string: String) {
        guard let firstCharacter = string.first else { return nil }
        
        let secondIndex = string.index(after: string.startIndex)
        let suffix = string[secondIndex...]
        
        guard
            let action = Action(firstCharacter),
            let value = Int(suffix)
        else { return nil }
        
        self.action = action
        self.value = value
    }
    
    func apply(to position: inout Position, facing direction: inout Direction) {
        switch action {
        case .direction(let direction):
            direction.apply(value: value, to: &position)
        case .movement(let movement):
            movement.apply(value: value, to: &position, facing: &direction)
        }
    }
    
    func apply(to position: inout Position, waypoint: inout Position) {
        switch action {
        case .direction(let direction):
            direction.apply(value: value, to: &waypoint)
        case .movement(let movement):
            movement.apply(value: value, to: &position, waypoint: &waypoint)
        }
    }

}
