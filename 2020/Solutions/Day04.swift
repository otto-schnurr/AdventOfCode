//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day04.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/4
//  Created by Otto Schnurr on 12/4/2020.
//

import XCTest

final class Day04: XCTestCase {

    func test_example() {
        let data = """
        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
        byr:1937 iyr:2017 cid:147 hgt:183cm

        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929

        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm

        hcl:#cfa07d eyr:2025 pid:166559648
        iyr:2011 ecl:brn hgt:59in
        """
        let lines = data.components(separatedBy: .newlines)
        let accounts = _parse(lines)
        XCTAssertEqual(
            accounts.filter { $0.validate(with: _simplePolicy) }.count, 2
        )
    }
    
    func test_solution() {
        let lines = Array(TestHarnessInput("input04.txt", includeEmptyLines: true)!)
        let accounts = _parse(lines)
        XCTAssertEqual(
            accounts.filter { $0.validate(with: _simplePolicy) }.count, 260
        )
    }
    
}


// MARK: - Private
private typealias Account = [String: String]

// reference: https://dev.to/onmyway133/how-to-make-simple-form-validator-in-swift-1hlg
private struct Rule {
    let validate: (String) -> Bool
    static let alwaysValid = Rule { _ in return true }
}

private let _simplePolicy: [String: Rule] = [
    "ecl": .alwaysValid,
    "pid": .alwaysValid,
    "eyr": .alwaysValid,
    "hcl": .alwaysValid,
    "byr": .alwaysValid,
    "iyr": .alwaysValid,
    "hgt": .alwaysValid
]

private func _parse(_ lines: [String]) -> [Account] {
    return lines.split(separator: "").map {
        Array($0)
            .map { line in line.components(separatedBy: .whitespaces) }
            .flatMap { $0 }
    }.map { Account(fields: $0) }
}

private extension Account {
    
    init(fields: [String]) {
        var result = Account()
        fields.forEach { field in
            let components = field.components(separatedBy: ":")
            result[components[0]] = components[1]
        }
        self = result
    }
    
    func validate(with policy: [String: Rule]) -> Bool {
        return policy.allSatisfy { key, rule in
            guard let value = self[key] else { return false }
            return rule.validate(value)
        }
    }
    
}
