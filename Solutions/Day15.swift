//
//  Day15.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day15: XCTestCase {
    
    func test_solutions() {
        var _ = Droid()
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input15.txt")!

private struct Droid {
    
    enum Direction: Word {
        case north = 1
        case south = 2
        case west = 3
        case east = 4
    }
    
    enum Status: Word {
        case wall = 0
        case moved = 1
        case movedToOxygen = 2
    }
    
    init() {
        computer = Computer(outputMode: .yield)
        computer.load(_program)
    }
    
    func move(_ direction: Direction) -> Status {
        computer.inputBuffer.append(direction.rawValue)
        computer.run()
        return Status(rawValue: computer.harvestOutput().first!)!
    }
    
    // MARK: Private
    private let computer: Computer
    
}
