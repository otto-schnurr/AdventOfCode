//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day11.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/11
//  Created by Otto Schnurr on 12/20/2019.
//

import XCTest
import AdventOfCode

final class Day11: XCTestCase {
    
    func test_solution() {
        var panels = Grid.PixelData()
        var robot = Robot()
        robot.run(on: &panels)
        XCTAssertEqual(panels.count, 2322)
        
        panels = [.zero: Color.white.pixelValue]
        robot.run(on: &panels)
        Grid(data: panels).render(backgroundValue: Color.black.pixelValue)
    }
    
}


// MARK: - Private
private enum Color: Word, CustomStringConvertible {
    case black = 0
    case white = 1
    
    var description: String { String(self.pixelValue) }
    
    var pixelValue: Pixel.Value {
        switch self {
        case .black: return "⬛️"
        case .white: return "⬜️"
        }
    }
    
}

private extension Pixel.Value {
    var colorValue: Color? {
        switch self {
        case "⬛️": return .black
        case "⬜️": return .white
        default:   return nil
        }
    }
}

private struct Robot {
    
    private(set) var position = Position.zero
    
    init() {
        computer = Computer(outputMode: .yield)
    }
    
    mutating func run(on panels: inout Grid.PixelData) {
        position = .zero
        direction = .north
        
        computer.load(_program)
        var shouldKeepRunning = true

        repeat {
            let input = panels[position]?.colorValue ?? .black
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
