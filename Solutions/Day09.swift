//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day09.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest
import AdventOfCode

final class Day09: XCTestCase {
    
    func test_example_1() {
        let program = [
            109, 1, 204, -1, 1001, 100, 1, 100,
            1008, 100, 16, 101, 1006, 101, 0, 99
        ]
        
        let computer = Computer()
        computer.load(program)
        computer.run()
        
        XCTAssertEqual(computer.harvestOutput(), program)
    }
    
    func test_example_2() {
        let program = [1102, 34915192, 34915192, 7, 4, 7, 99, 0]
        
        let computer = Computer()
        computer.load(program)
        computer.run()
        
        XCTAssertEqual(computer.harvestOutput(), [1_219_070_632_396_864])
    }
    
    func test_example_3() {
        let program = [104, 1125899906842624, 99]
        
        let computer = Computer()
        computer.load(program)
        computer.run()
        
        XCTAssertEqual(computer.harvestOutput(), [1_125_899_906_842_624])
    }
    
    func test_solution() {
        let computer = Computer()
        computer.load(_program)
        computer.inputBuffer.append(1)
        computer.run()
        
        XCTAssertEqual(computer.harvestOutput(), [2350741403])
        
        computer.load(_program)
        computer.inputBuffer.append(2)
        computer.run()
        
        XCTAssertEqual(computer.harvestOutput(), [53088])
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input09.txt")!
