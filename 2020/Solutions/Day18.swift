//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day18.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/18
//  Created by Otto Schnurr on 12/21/2020.
//

import XCTest

final class Day18: XCTestCase {

    func test_examples() {
        let lines = """
        2 * 3 + (4 * 5)
        5 + (8 * 3 + 9 + 3 * 4 * 3)
        5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
        ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
        """.components(separatedBy: .newlines)

        let results = lines.map { _evaluate($0) }
        XCTAssertEqual(results, [ 26, 437, 12_240, 13_632 ])
    }

    func test_solution() {
        let lines = Array(TestHarnessInput("input18.txt")!)
        let results = lines.map { _evaluate($0) }
        XCTAssertEqual(results.reduce(0, +), 4_940_631_886_147)
    }
    
}


// MARK: - Private
private func _evaluate(_ line: String) -> Int {
    var index = line.startIndex
    return _evaluate(line, from: &index)
}

private func _evaluate(_ line: String, from index: inout String.Index) -> Int {
    var accumulator = 0
    var operation: Character?
    
    while index < line.endIndex {
        let character = line[index]
        index = line.index(after: index)

        var nextValue: Int?
        
        if let value = character.wholeNumberValue {
            nextValue = value
        } else {
            switch character {
            case "+", "*": operation = character
            case "(": nextValue = _evaluate(line, from: &index)
            case ")": return accumulator
            default: break
            }
        }
        
        if let nextValue = nextValue {
            if let _operation = operation {
                operation = nil
                
                switch _operation {
                case "+": accumulator += nextValue
                case "*": accumulator *= nextValue
                default: break
                }
            } else {
                // This is the first value before any operations.
                accumulator = nextValue
            }
        }
    }
    
    return accumulator
}
