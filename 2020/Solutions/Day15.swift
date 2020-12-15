//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day15.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/15
//  Created by Otto Schnurr on 12/15/2020.
//

import XCTest

final class Day15: XCTestCase {

    func test_examples() {
        XCTAssertEqual(_memoryGame(for: [0, 3, 6]), 436)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
private func _memoryGame(for startingNumbers: [Int]) -> Int {
    var history = [Int: Int]()
    var nextNumber = 0
    
    for turn in 1...2019 {
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
