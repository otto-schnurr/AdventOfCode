//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day09.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/9
//  Created by Otto Schnurr on 12/10/2020.
//

import Algorithms
import XCTest

final class Day09: XCTestCase {

    func test_example() {
        let numbers = [
            35, 20, 15, 25, 47,
            40, 62, 55, 65, 95,
            102, 117, 150, 182, 127,
            219, 299, 277, 309, 576
        ]
        XCTAssertEqual(_firstCypherFailure(for: numbers, poolSize: 5)!, 127)
    }

    func test_solution() {
        let numbers = TestHarnessInput("input09.txt")!.compactMap { Int($0) }
        XCTAssertEqual(_firstCypherFailure(for: numbers, poolSize: 25)!, 2089807806)
    }
    
}


// MARK: - Private
func _firstCypherFailure(for numbers: [Int], poolSize: Int) -> Int? {
    guard numbers.count > poolSize + 1 else { return nil }
    
    for index in (0 ..<  (numbers.count - poolSize)) {
        let available = numbers[index ..< index + poolSize]
            .combinations(ofCount: 2)
            .map { $0.reduce(0, +) }
        let availableValues = Set(available)
        
        let value = numbers[index + poolSize]
        if !availableValues.contains(value) { return value }
    }
    
    return nil
}
