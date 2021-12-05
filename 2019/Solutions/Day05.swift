//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day05.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/5
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest
import AdventOfCode

final class Day05: XCTestCase {
    
    func test_solution() {
        let computer = Computer()
        computer.load(_program)
        computer.inputBuffer = [1]
        computer.run()
        XCTAssertEqual(
            computer.harvestOutput(), [0, 0, 0, 0, 0, 0, 0, 0, 0, 16489636]
        )

        computer.load(_program)
        computer.inputBuffer = [5]
        computer.run()
        XCTAssertEqual(computer.harvestOutput(), [9386583])
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input05.txt")!
