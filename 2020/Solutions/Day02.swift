//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day02.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/2
//  Created by Otto Schnurr on 12/2/2020.
//

import Algorithms
import XCTest

final class Day02: XCTestCase {

    func test_example() {
        let entries = [
            "1-3 a: abcde",
            "1-3 b: cdefg",
            "2-9 c: ccccccccc"
        ].compactMap { PasswordEntry(string: $0) }
        XCTAssertEqual(entries.filter { $0.isValid }.count, 2)
    }
    
}


// MARK: - Private
private struct PasswordEntry {

    let requiredCharacter: Character
    let range: Range<Int>
    let password: String

    var isValid: Bool {
        let count = password.filter { $0 == requiredCharacter }.count
        return range.contains(count)
    }
    
    init?(string: String) {
        let components = string
            .filter { $0 != ":" }
            .split(separator: " ")
            .map { String($0) }
        guard
            components.count == 3,
            let range = Range(string: components[0])
        else { return nil }

        requiredCharacter = Character(components[1])
        self.range = range
        password = components[2]
    }
    
}

private extension Range where Element == Int {
    init?(string: String) {
        let components = string.split(separator: "-")
        guard
            components.count == 2,
            let lowerBound = Int(components[0]),
            let upperBound = Int(components[1])
        else { return nil }
        
        self = Range(lowerBound...upperBound)
    }
}
