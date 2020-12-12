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

import Algorithms
import XCTest

final class Day12: XCTestCase {

    func test_examples() {
        let lines = """
        F10
        N3
        F7
        R90
        F11
        """.components(separatedBy: .newlines)
        let instructions = lines.map { Insruction($0)! }
        
        var position = Position.zero
        var direction = Direction.east
        
        instructions.forEach { $0.apply(to: &position, facing: &direction)}
        XCTAssertEqual(abs(position.x) + abs(position.y), 25)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
private typealias Position = SIMD2<Int>

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

private struct Insruction {
    
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
    
}
