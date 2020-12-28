//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day19.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/19
//  Created by Otto Schnurr on 12/27/2020.
//

import XCTest

// reference: https://www.reddit.com/r/adventofcode/comments/kg1mro/2020_day_19_solutions/ggdxmpa/
final class Day19: XCTestCase {

    func test_examples() {
        let lines = """
        0: 4 1 5
        1: 2 3 | 3 2
        2: 4 4 | 5 5
        3: 4 5 | 5 4
        4: "a"
        5: "b"

        ababbb
        bababa
        abbbab
        aaabbb
        aaaabbb
        """.components(separatedBy: .newlines)
        let (rules, messages) = _parse(lines)
        let _ = messages.filter {
            _validate(string: $0, with: rules, pending: [0])
        }
//        XCTAssertEqual(validMessages.count, 2)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
private typealias RuleID = Int
private typealias Rules = [RuleID: Components]

private enum Components {
    case character(Character)
    case subRules([[RuleID]])
}

private func _parse(_ lines: [String]) -> (rules: Rules, messages: [String]) {
    // !!!: implement me
    return ([:], [ ])
}

private func _validate(
    string: String, with rules: Rules, pending: [RuleID]
) -> Bool {
    // !!!: implement me
    return false
}
