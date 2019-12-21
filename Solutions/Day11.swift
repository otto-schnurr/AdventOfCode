//
//  Day11.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/20/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

class Day11: XCTestCase {
    
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
        var panels = Panels()
        var robot = Robot()
        robot.run(on: &panels)
        XCTAssertEqual(panels.count, 2322)
        
        panels = [.zero: .white]
        robot.position = .zero
        robot.run(on: &panels)
        render_hack(panels)
    }
    
}


// MARK: - Private
private typealias Panels = [Coordinate: Color]

private enum Color: Word, CustomStringConvertible {
    case black = 0
    case white = 1
    
    var description: String { String(self.asCharacter) }
    
    var asCharacter: Character {
        switch self {
        case .black: return Character("⬛️")
        case .white: return Character("⬜️")
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
    
    var position = Coordinate.zero
    
    init() {
        computer = Computer(outputMode: .yield)
    }
    
    mutating func run(on panels: inout Panels) {
        computer.load(_program)
        var shouldKeepRunning = true

        repeat {
            computer.inputBuffer.append(
                panels[position]?.rawValue ?? Color.black.rawValue
            )
            var output = Buffer()
            
            computer.run()
            output += computer.harvestOutput()
            computer.run()
            output += computer.harvestOutput()
            
            guard output.count >= 2 else {
                shouldKeepRunning = false
                continue
            }
            
            panels[position] = Color(rawValue: output[0])!
            direction = direction.turned(Turn(rawValue: output[1])!)
            position = position + direction.asCoordinate
        } while shouldKeepRunning
    }
    
    // MARK: Private
    private let computer: Computer
    private var direction = Direction.right
    
}

private extension ClosedRange where Element == Int {
    func expanded(toInclude bound: Bound) -> Self {
        return Swift.min(bound, lowerBound) ... Swift.max(bound, upperBound)
    }
}

// TODO: Figure out why the axis are reversed.
private func render_hack(_ panels: Panels) {
    let rowRange = panels.reduce(0...0) { $0.expanded(toInclude: $1.key.y) }
    let columnRange = panels.reduce(0...0) { $0.expanded(toInclude: $1.key.x) }
    
    let emptyRow = Array(repeating: Color.black.asCharacter, count: columnRange.count)
    var panelDisplay = Array(repeating: emptyRow, count: rowRange.count)
    
    panels.forEach {
        let rowIndex = $0.key.y - rowRange.lowerBound
        let columnIndex = $0.key.x - columnRange.lowerBound
        panelDisplay[rowIndex][columnIndex] = $0.value.asCharacter
    }
    panelDisplay.forEach { print(String($0)) }
}

private let _program: Program = [
    3, 8, 1005, 8, 304, 1106, 0, 11, 0, 0, 0, 104, 1, 104, 0, 3, 8, 102,
    -1, 8, 10, 101, 1, 10, 10, 4, 10, 1008, 8, 1, 10, 4, 10, 1002, 8, 1,
    29, 2, 103, 1, 10, 1, 106, 18, 10, 3, 8, 102, -1, 8, 10, 1001, 10, 1,
    10, 4, 10, 1008, 8, 1, 10, 4, 10, 102, 1, 8, 59, 2, 102, 3, 10, 2,
    1101, 12, 10, 3, 8, 102, -1, 8, 10, 1001, 10, 1, 10, 4, 10, 108, 0, 8,
    10, 4, 10, 101, 0, 8, 88, 3, 8, 102, -1, 8, 10, 1001, 10, 1, 10, 4,
    10, 108, 1, 8, 10, 4, 10, 101, 0, 8, 110, 2, 108, 9, 10, 1006, 0, 56,
    3, 8, 102, -1, 8, 10, 1001, 10, 1, 10, 4, 10, 108, 0, 8, 10, 4, 10,
    101, 0, 8, 139, 1, 108, 20, 10, 3, 8, 102, -1, 8, 10, 101, 1, 10, 10,
    4, 10, 108, 0, 8, 10, 4, 10, 102, 1, 8, 165, 1, 104, 9, 10, 3, 8, 102,
    -1, 8, 10, 101, 1, 10, 10, 4, 10, 1008, 8, 0, 10, 4, 10, 1001, 8, 0,
    192, 2, 9, 14, 10, 2, 1103, 5, 10, 1, 1108, 5, 10, 3, 8, 1002, 8, -1,
    10, 101, 1, 10, 10, 4, 10, 1008, 8, 1, 10, 4, 10, 102, 1, 8, 226,
    1006, 0, 73, 1006, 0, 20, 1, 1106, 11, 10, 1, 1105, 7, 10, 3, 8, 102,
    -1, 8, 10, 1001, 10, 1, 10, 4, 10, 108, 0, 8, 10, 4, 10, 1001, 8, 0,
    261, 3, 8, 102, -1, 8, 10, 101, 1, 10, 10, 4, 10, 108, 1, 8, 10, 4,
    10, 1002, 8, 1, 283, 101, 1, 9, 9, 1007, 9, 1052, 10, 1005, 10, 15,
    99, 109, 626, 104, 0, 104, 1, 21101, 48062899092, 0, 1, 21101, 0, 321,
    0, 1105, 1, 425, 21101, 936995300108, 0, 1, 21101, 0, 332, 0, 1106, 0,
    425, 3, 10, 104, 0, 104, 1, 3, 10, 104, 0, 104, 0, 3, 10, 104, 0, 104,
    1, 3, 10, 104, 0, 104, 1, 3, 10, 104, 0, 104, 0, 3, 10, 104, 0, 104,
    1, 21102, 209382902951, 1, 1, 21101, 379, 0, 0, 1106, 0, 425, 21102,
    179544747200, 1, 1, 21102, 390, 1, 0, 1106, 0, 425, 3, 10, 104, 0,
    104, 0, 3, 10, 104, 0, 104, 0, 21102, 1, 709488292628, 1, 21102, 1,
    413, 0, 1106, 0, 425, 21101, 0, 983929868648, 1, 21101, 424, 0, 0,
    1105, 1, 425, 99, 109, 2, 22101, 0, -1, 1, 21102, 40, 1, 2, 21102,
    456, 1, 3, 21101, 446, 0, 0, 1106, 0, 489, 109, -2, 2106, 0, 0, 0, 1,
    0, 0, 1, 109, 2, 3, 10, 204, -1, 1001, 451, 452, 467, 4, 0, 1001, 451,
    1, 451, 108, 4, 451, 10, 1006, 10, 483, 1102, 0, 1, 451, 109, -2,
    2105, 1, 0, 0, 109, 4, 1201, -1, 0, 488, 1207, -3, 0, 10, 1006, 10,
    506, 21102, 1, 0, -3, 21202, -3, 1, 1, 21201, -2, 0, 2, 21101, 0, 1,
    3, 21101, 525, 0, 0, 1105, 1, 530, 109, -4, 2105, 1, 0, 109, 5, 1207,
    -3, 1, 10, 1006, 10, 553, 2207, -4, -2, 10, 1006, 10, 553, 21202, -4,
    1, -4, 1105, 1, 621, 21201, -4, 0, 1, 21201, -3, -1, 2, 21202, -2, 2,
    3, 21102, 1, 572, 0, 1106, 0, 530, 21201, 1, 0, -4, 21101, 0, 1, -1,
    2207, -4, -2, 10, 1006, 10, 591, 21102, 0, 1, -1, 22202, -2, -1, -2,
    2107, 0, -3, 10, 1006, 10, 613, 22101, 0, -1, 1, 21101, 0, 613, 0,
    106, 0, 488, 21202, -2, -1, -2, 22201, -4, -2, -4, 109, -5, 2106, 0, 0
]
