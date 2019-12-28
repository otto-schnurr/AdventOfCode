//
//  Day11.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/20/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day11: XCTestCase {
    
    func test_directions() {
        XCTAssertEqual(Direction.up.turned(.left), .left)
        XCTAssertEqual(Direction.up.turned(.right), .right)
        
        XCTAssertEqual(Direction.right.turned(.left), .up)
        XCTAssertEqual(Direction.right.turned(.right), .down)
        
        XCTAssertEqual(Direction.down.turned(.left), .right)
        XCTAssertEqual(Direction.down.turned(.right), .left)
        
        XCTAssertEqual(Direction.left.turned(.left), .down)
        XCTAssertEqual(Direction.left.turned(.right), .up)
    }
    
    func test_solution() {
        var panels = Display(backgroundColor: "⬛️")
        var robot = Robot()
        robot.run(on: &panels)
        XCTAssertEqual(panels.initialPixelCount, 2322)
        
        panels = Display(backgroundColor: "⬛️")
        panels[.zero] = Color.white.characterValue
        robot.run(on: &panels)
        panels.render()
    }
    
}


// MARK: - Private
private enum Color: Word, CustomStringConvertible {
    case black = 0
    case white = 1
    
    var description: String { String(self.characterValue) }
    
    var characterValue: Character {
        switch self {
        case .black: return "⬛️"
        case .white: return "⬜️"
        }
    }
    
}

private extension Character {
    var colorValue: Color? {
        switch self {
        case "⬛️": return .black
        case "⬜️": return .white
        default:   return nil
        }
    }
}

private enum Turn: Word {
    case left = 0
    case right = 1
}

private enum Direction {
    
    case up, down, left, right
    
    var asCoordinate: Coordinate {
        switch self {
        case .up:    return Coordinate(0, -1)
        case .down:  return Coordinate(0, +1)
        case .left:  return Coordinate(-1, 0)
        case .right: return Coordinate(1, 0)
        }
    }
    
    func turned(_ turn: Turn) -> Self {
        switch turn {
        case .left:
            switch self {
            case .up: return .left
            case .down: return .right
            case .left: return .down
            case .right: return .up
            }

        case .right:
            switch self {
            case .up: return .right
            case .down: return .left
            case .left: return .up
            case .right: return .down
            }
        }
    }
    
    func turnedLeft() -> Self {
        switch self {
        case .up: return .left
        case .down: return .right
        case .left: return .down
        case .right: return .up
        }
    }
    
    func turnedRight() -> Self {
        switch self {
        case .up: return .right
        case .down: return .left
        case .left: return .up
        case .right: return .down
        }
    }
    
}

private struct Robot {
    
    private(set) var position = Coordinate.zero
    
    init() {
        computer = Computer(outputMode: .yield)
    }
    
    mutating func run(on panels: inout Display) {
        position = .zero
        direction = .up
        
        computer.load(_program)
        var shouldKeepRunning = true

        repeat {
            let input = panels[position].colorValue ?? .black
            computer.inputBuffer.append(input.rawValue)
            
            computer.run()
            computer.run()
            let output = computer.harvestOutput()
            
            guard output.count >= 2 else {
                shouldKeepRunning = false
                continue
            }
            
            panels[position] = Color(rawValue: output[0])!.characterValue
            direction = direction.turned(Turn(rawValue: output[1])!)
            position = position + direction.asCoordinate
        } while shouldKeepRunning
    }
    
    // MARK: Private
    private let computer: Computer
    private var direction = Direction.up
    
}

private extension ClosedRange where Element == Int {
    func expanded(toInclude bound: Bound) -> Self {
        return Swift.min(bound, lowerBound) ... Swift.max(bound, upperBound)
    }
}

private let _program = Program(testHarnessResource: "input11.txt")!
