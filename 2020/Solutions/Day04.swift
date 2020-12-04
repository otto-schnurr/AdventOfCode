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
        let lines = _scan(data)
        XCTAssertEqual(_validate(lines), 2)
    }
    
    func test_solution() {
        let lines = Array(TestHarnessInput("input04.txt", includeEmptyLines: true)!)
        XCTAssertEqual(_validate(lines), 260)
    }
    
}


// MARK: - Private
private let _requiredKeys = Set(
    arrayLiteral: "ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"
)

private func _scan(_ string: String) -> [String] {
    return string.components(separatedBy: .newlines)
}

private func _validate(_ lines: [String]) -> Int {
    let entries = lines.split(separator: "").map {
        Array($0)
            .map { line in line.components(separatedBy: .whitespaces) }
            .flatMap { $0 }
    }
    
    let keys = entries.map { $0.map { String($0.prefix(3)) } }
    return keys.filter { _requiredKeys.isSubset(of: $0) }.count
}
