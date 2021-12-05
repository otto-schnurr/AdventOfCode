//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

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
        let validMessages = messages.filter {
            _validate(string: $0, with: rules, pending: [0])
        }
        XCTAssertEqual(validMessages.count, 2)
    }

    func test_solution() {
        let lines = Array(TestHarnessInput("input19.txt", includeEmptyLines: true)!)

        let (rules, messages) = _parse(lines)
        var validMessages = messages.filter {
            _validate(string: $0, with: rules, pending: [0])
        }
        XCTAssertEqual(validMessages.count, 180)
        
        var newRules = rules
        newRules[8] = Components(words: [ "42", "|", "42", "8"])!
        newRules[11] = Components(words: [ "42", "31", "|", "42", "11", "31" ])!

        validMessages = messages.filter {
            _validate(string: $0, with: newRules, pending: [0])
        }
        XCTAssertEqual(validMessages.count, 323)
    }
    
}


// MARK: - Private
private typealias RuleID = Int
private typealias Rules = [RuleID: Components]

private enum Components {
    
    case character(Character)
    case subRules([[RuleID]])
    
    init?(words: [String]) {
        guard let firstWord = words.first else { return nil }
        
        if firstWord.hasPrefix("\"") {
            self = .character(firstWord.dropFirst().first!)
        } else {
            let ruleIDs = words.split(separator: "|").map { group in
                group.compactMap { Int($0) }
            }
            self = .subRules(ruleIDs)
        }
    }
    
}

private func _parse(_ lines: [String]) -> (rules: Rules, messages: [String]) {
    let groups = lines.split(separator: "")
    var rules = Rules()
    groups[0].forEach { _parseRule(from: $0, to: &rules) }
    return (rules: rules, messages: groups[1].map { String($0) })
}

private func _parseRule(from line: String, to rules: inout Rules) {
    let words = line.components(separatedBy: .whitespaces)
    guard
        words.count >= 2,
        let ruleID = Int(words[0].dropLast()),
        let components = Components(words: Array(words.dropFirst()))
    else { return }
    
    rules[ruleID] = components
}

private func _validate(
    string: String, with rules: Rules, pending: [RuleID]
) -> Bool {
    guard
        let character = string.first,
        let ruleID = pending.first,
        let components = rules[ruleID]
    else { return string.isEmpty && pending.isEmpty }

    let nextString = String(string.dropFirst())
    let nextPending = Array(pending.dropFirst())
    
    switch components {
    case .character(let requiredCharacter):
        if character != requiredCharacter {
            return false
        } else {
            return _validate(
                string: nextString,
                with: rules,
                pending: nextPending
            )
        }
    case .subRules(let ruleGroups):
        let any = ruleGroups.first {
            _validate(
                string: string,
                with: rules,
                pending: $0 + nextPending
            )
        }
        return any != nil
    }
}
