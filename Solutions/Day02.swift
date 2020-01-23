//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day02.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest
import AdventOfCode

final class Day02: XCTestCase {
    
    func test_solution() {
        func makeProgram(noun: Word, verb: Word) -> Program {
            var program = _program
            program[1] = noun
            program[2] = verb
            return program
        }
        
        let computer = Computer()
        computer.load(makeProgram(noun: 12, verb: 2))
        computer.run()
        XCTAssertEqual(computer.firstWord, 4570637)
        
        computer.load(makeProgram(noun: 54, verb: 85))
        computer.run()
        XCTAssertEqual(computer.firstWord, 19690720)
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input02.txt")!
