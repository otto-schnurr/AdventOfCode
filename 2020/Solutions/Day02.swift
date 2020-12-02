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
        ].compactMap { PasswordEntry(entry: $0) }
        
        XCTAssertEqual(entries.filter { $0.isValidForSledRental }.count, 2)
        XCTAssertEqual(entries.filter { $0.isValid }.count, 1)
    }
    
    func test_solution() {
        let entries = TestHarnessInput("input02.txt")!
            .compactMap { PasswordEntry(entry: $0) }
        
        XCTAssertEqual(entries.filter { $0.isValidForSledRental }.count, 628)
        XCTAssertEqual(entries.filter { $0.isValid }.count, 705)
    }
    
}


// MARK: - Private
private struct PasswordEntry {

    let first: Int
    let second: Int
    let requiredCharacter: Character
    let password: String

    var isValid: Bool {
        let firstIndex =
            password.index(password.startIndex, offsetBy: first - 1)
        let secondIndex =
            password.index(password.startIndex, offsetBy: second - 1)
        
        let firstMatch =
            password.count >= first &&
            password[firstIndex] == requiredCharacter
        let secondMatch =
            password.count >= second &&
            password[secondIndex] == requiredCharacter
        
        return firstMatch != secondMatch
    }
    
    var isValidForSledRental: Bool {
        let count = password.filter { $0 == requiredCharacter }.count
        return Range(first...second).contains(count)
    }
    
    init?(entry: String) {
        let components = entry
            .filter { $0 != ":" }
            .split(separator: " ")
            .map { String($0) }
        guard
            components.count == 3,
            let (first, second) = _parse(range: components[0])
        else { return nil }

        self.first = first
        self.second = second
        requiredCharacter = Character(components[1])
        password = components[2]
    }
    
}

private func _parse(range: String) -> (Int, Int)? {
    let components = range.split(separator: "-")
    guard
        components.count == 2,
        let first = Int(components[0]),
        let second = Int(components[1])
    else { return nil }
    
    return (first, second)
}
