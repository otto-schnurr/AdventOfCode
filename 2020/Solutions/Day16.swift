//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day16.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/16
//  Created by Otto Schnurr on 12/16/2020.
//

import XCTest

final class Day16: XCTestCase {

    func test_examples() {
        let lines = """
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50

        your ticket:
        7,1,14

        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12
        """.components(separatedBy: .newlines)
        XCTAssertEqual(_invalidValues(in: lines).reduce(0, +), 71)
    }

    func test_solution() {
        let lines = Array(TestHarnessInput("input16.txt", includeEmptyLines: true)!)
        XCTAssertEqual(_invalidValues(in: lines).reduce(0, +), 20_013)
    }
    
}


// MARK: - Private
private func _invalidValues(in lines: [String]) -> [Int] {
    let groups = lines.split(separator: "").map { Array($0) }
    guard groups.count >= 3 else { return [ ] }
    
    let ranges = _parseRanges(from: groups[0])
    return _parseValues(from: groups[2]).filter { value in
        !ranges.contains { $0.contains(value) }
    }
}

private func _parseRanges(from lines: [String]) -> [ClosedRange<Int>] {
    return lines.map {
         $0.components(separatedBy: .whitespaces)
           .compactMap { ClosedRange<Int>(string: $0) }
    }.flatMap { $0 }
}

private func _parseValues(from lines: [String]) -> [Int] {
    return lines.dropFirst().map {
        $0.components(separatedBy: .punctuationCharacters)
          .compactMap { Int($0) }
    }.flatMap { $0 }
}

private extension ClosedRange where Element == Int {
    init?(string: String) {
        let words = string.components(separatedBy: "-")
        guard
            words.count >= 2,
            let minimum = Int(words[0]),
            let maximum = Int(words[1])
        else { return nil }
        
        self = minimum ... maximum
    }
}
