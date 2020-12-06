//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day06.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/6
//  Created by Otto Schnurr on 12/6/2020.
//

import XCTest

final class Day06: XCTestCase {

    func test_example() {
        let data = """
        abc

        a
        b
        c

        ab
        ac

        a
        a
        a
        a

        b
        """
        let lines = data.components(separatedBy: .newlines)
        let groups = _parse(lines)
        XCTAssertEqual(groups.map { $0.count }.reduce(0, +), 11)
    }
    
    func test_solution() {
        let lines = Array(TestHarnessInput("input06.txt", includeEmptyLines: true)!)
        let groups = _parse(lines)
        XCTAssertEqual(groups.map { $0.count }.reduce(0, +), 6_612)
    }
    
}


// MARK: - Private
typealias Form = Set<Character>

private func _parse(_ lines: [String]) -> [Form] {
    return lines.split(separator: "").map { group in
        group.map {
            Set($0)
        }.reduce(Form()) { result, element in
            return result.union(element)
        }
    }
}
