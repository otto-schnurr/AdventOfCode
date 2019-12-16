//
//  Day09.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

class Day09: XCTestCase {
    
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
    
}


// MARK: - Private
private let _program = [
    0
]
