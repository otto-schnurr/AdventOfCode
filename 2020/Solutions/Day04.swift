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

    func DISABLED_test_example() {
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
        XCTAssertEqual(_validCount(for: lines), 2)
    }
    
    func test_solution() {
    }
    
}


// MARK: - Private
private func _scan(_ string: String) -> [String] {
    // !!!: implement me
    return [ ]
}

private func _validCount(for lines: [String]) -> Int {
    // !!!: impelement me
    return 0
}
