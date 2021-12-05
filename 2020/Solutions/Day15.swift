//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day15.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/15
//  Created by Otto Schnurr on 12/15/2020.
//

import XCTest

final class Day15: XCTestCase {

    func test_examples_part1() {
        XCTAssertEqual(_memoryGame(for: [0, 3, 6], turns: 2020), 436)
        XCTAssertEqual(_memoryGame(for: [1, 3, 2], turns: 2020), 1)
        XCTAssertEqual(_memoryGame(for: [2, 1, 3], turns: 2020), 10)
        XCTAssertEqual(_memoryGame(for: [1, 2, 3], turns: 2020), 27)
        XCTAssertEqual(_memoryGame(for: [2, 3, 1], turns: 2020), 78)
        XCTAssertEqual(_memoryGame(for: [3, 2, 1], turns: 2020), 438)
        XCTAssertEqual(_memoryGame(for: [3, 1, 2], turns: 2020), 1_836)
    }

    func TOO_SLOW_test_examples_part2() {
        XCTAssertEqual(_memoryGame(for: [0, 3, 6], turns: 30_000_000), 175_594)
        XCTAssertEqual(_memoryGame(for: [1, 3, 2], turns: 30_000_000), 2_578)
        XCTAssertEqual(_memoryGame(for: [2, 1, 3], turns: 30_000_000), 3_544_142)
        XCTAssertEqual(_memoryGame(for: [1, 2, 3], turns: 30_000_000), 261_214)
        XCTAssertEqual(_memoryGame(for: [2, 3, 1], turns: 30_000_000), 6_895_259)
        XCTAssertEqual(_memoryGame(for: [3, 2, 1], turns: 30_000_000), 18)
        XCTAssertEqual(_memoryGame(for: [3, 1, 2], turns: 30_000_000), 362)
    }

    func test_solution_part2() {
        XCTAssertEqual(_memoryGame(for: [7, 12, 1, 0, 16, 2], turns: 2020), 410)
    }

    func TOO_SLOW_test_solution_part2() {
        XCTAssertEqual(_memoryGame(for: [7, 12, 1, 0, 16, 2], turns: 30_000_000), 238)
    }
    
}


// MARK: - Private
private func _memoryGame(for startingNumbers: [Int], turns: Int) -> Int {
    var history = [Int: Int]()
    var nextNumber = 0
    
    for turn in 1 ..< turns {
        var currentNumber = nextNumber
        
        if turn <= startingNumbers.count {
            currentNumber = startingNumbers[turn - 1]
            nextNumber = 0
        } else if let history = history[currentNumber] {
            nextNumber = turn - history
        } else {
            nextNumber = 0
        }
        
        history[currentNumber] = turn
    }
    
    return nextNumber
}
