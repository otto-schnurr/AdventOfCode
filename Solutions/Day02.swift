//
//  Day02.swift
//  AdventOfCode/Solutions
//  
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

class Day02: XCTestCase {
    
    func test_solution() {
        func makeProgram(noun: Word, verb: Word) -> Program {
            var program = _program
            program[1] = noun
            program[2] = verb
            return program
        }
        
        let computer = Computer(program: makeProgram(noun: 12, verb: 2))
        computer.run()
        XCTAssertEqual(computer.firstWord, 4570637)
        
        computer.load(program: makeProgram(noun: 54, verb: 85))
        computer.run()
        XCTAssertEqual(computer.firstWord, 19690720)
    }
    
}


// MARK: - Private
private let _program = [
    1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 6, 1, 19,
    1, 19, 5, 23, 2, 10, 23, 27, 2, 27, 13, 31, 1, 10, 31, 35, 1, 35, 9, 39,
    2, 39, 13, 43, 1, 43, 5, 47, 1, 47, 6, 51, 2, 6, 51, 55, 1, 5, 55, 59,
    2, 9, 59, 63, 2, 6, 63, 67, 1, 13, 67, 71, 1, 9, 71, 75, 2, 13, 75, 79,
    1, 79, 10, 83, 2, 83, 9, 87, 1, 5, 87, 91, 2, 91, 6, 95, 2, 13, 95, 99,
    1, 99, 5, 103, 1, 103, 2, 107, 1, 107, 10, 0, 99, 2, 0, 14, 0
]
