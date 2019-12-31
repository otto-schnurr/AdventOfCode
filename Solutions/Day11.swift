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
    
    func test_solution() {
        var panels = Display(backgroundColor: "⬛️")
        var robot = Robot()
        robot.run(on: &panels)
        XCTAssertEqual(panels.initialPixelCount, 2322)
        
        panels = Display(backgroundColor: "⬛️")
        panels[.zero] = Color.white.pixelValue
        robot.run(on: &panels)
        panels.render()
    }
    
}


// MARK: - Private
private enum Color: Word, CustomStringConvertible {
    case black = 0
    case white = 1
    
    var description: String { String(self.pixelValue) }
    
    var pixelValue: Display.Pixel {
        switch self {
        case .black: return "⬛️"
        case .white: return "⬜️"
        }
    }
    
}

private extension Display.Pixel {
    var colorValue: Color? {
        switch self {
        case "⬛️": return .black
        case "⬜️": return .white
        default:   return nil
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
        direction = .north
        
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
            
            panels[position] = Color(rawValue: output[0])!.pixelValue
            direction = direction.turned(Direction.Turn(rawValue: output[1])!)
            position = position + direction
        } while shouldKeepRunning
    }
    
    // MARK: Private
    private let computer: Computer
    private var direction = Direction.north
    
}

private extension ClosedRange where Element == Int {
    func expanded(toInclude bound: Bound) -> Self {
        return Swift.min(bound, lowerBound) ... Swift.max(bound, upperBound)
    }
}

private let _program = Program(testHarnessResource: "input11.txt")!
