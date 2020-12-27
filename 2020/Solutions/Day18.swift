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
    let expression = line.compactMap { Token(character: $0) }
    let result = _simplify(expression)
    switch result[0] {
    case .value(let result): return result
    default:                 return 0
    }
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

private func _simplify(_ expression: [Token]) -> [Token] {
    let firstPass = _reduceSubexpressions(in: expression)
    return _reduceOperations(in: firstPass)
}

private func _reduceSubexpressions(in expression: [Token]) -> [Token] {
    var subexpression = [Token]()
    
    return expression.reduce(into: [ ]) { result, token in
        switch token {
        case .beginGroup, .endGroup:
            subexpression.append(token)
        default:
            if subexpression.isEmpty {
                result.append(token)
            } else {
                subexpression.append(token)
            }
        }
        
        if !subexpression.isEmpty && subexpression.nestedCount == 0 {
            result += _simplify(subexpression.dropFirst().dropLast())
            subexpression = [ ]
        }
    }
}

private func _reduceOperations(in expression: [Token]) -> [Token] {
    return expression.reduce(into: [ ]) { result, token in
        result.append(token)
        let suffix = result.suffix(3)
        guard suffix.count == 3 else { return }
        
        switch (suffix[0], suffix[1], suffix[2]) {
        case (.value(let lhs), .add, .value(let rhs)):
            result.removeLast(3)
            result.append(.value(lhs + rhs))
        case (.value(let lhs), .multiply, .value(let rhs)):
            result.removeLast(3)
            result.append(.value(lhs * rhs))
        default:
            break
        }
    }
}

private extension Array where Element == Token {
    var nestedCount: Int {
        return self.reduce(0) { result, token in
            switch token {
            case .beginGroup: return result + 1
            case .endGroup:   return result - 1
            default:          return result
            }
        }
    }
}
