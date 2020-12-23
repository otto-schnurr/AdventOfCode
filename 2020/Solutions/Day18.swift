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

    func test_example_part1() {
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
    let tokens = line.compactMap { Token(character: $0) }
    var index = 0
    return _evaluate(tokens, from: &index)
}

private enum Token {

    case value(Int)
    case add, multiply
    case beginGroup, endGroup

    init?(character: Character) {
        if let value = character.wholeNumberValue {
            self = .value(value)
        } else {
            switch character {
            case "+": self = .add
            case "*": self = .multiply
            case "(": self = .beginGroup
            case ")": self = .endGroup
            default:  return nil
            }
        }
    }

}

extension Token: CustomStringConvertible {
    var description: String {
        switch self {
        case .value(let value): return String(value)
        case .add:              return "+"
        case .multiply:         return "*"
        case .beginGroup:       return "("
        case .endGroup:         return ")"
        }
    }
}

private func _evaluate(_ tokens: [Token], from index: inout Int) -> Int {
    var accumulator = 0
    var operation: Token?
    
    while index < tokens.count {
        let token = tokens[index]
        index += 1

        var nextValue: Int?
        
        switch token {
        case .value(let value):
            nextValue = value
        case .add, .multiply:
            operation = token
        case .beginGroup:
            nextValue = _evaluate(tokens, from: &index)
        case .endGroup:
            return accumulator
        }
        
        if let nextValue = nextValue {
            if let _operation = operation {
                operation = nil
                
                switch _operation {
                case .add:
                    accumulator += nextValue
                case .multiply:
                    accumulator *= nextValue
                default:
                    break
                }
            } else {
                // This is the first value before any operations.
                accumulator = nextValue
            }
        }
    }
    
    return accumulator
}
