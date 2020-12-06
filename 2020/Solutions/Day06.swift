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
        XCTAssertEqual(_collateAll(groups).map { $0.count }.reduce(0, +), 11)
        XCTAssertEqual(_collateCommon(groups).map { $0.count }.reduce(0, +), 6)
    }
    
    func test_solution() {
        let lines = Array(TestHarnessInput("input06.txt", includeEmptyLines: true)!)
        let groups = _parse(lines)
        XCTAssertEqual(_collateAll(groups).map { $0.count }.reduce(0, +), 6_612)
        XCTAssertEqual(_collateCommon(groups).map { $0.count }.reduce(0, +), 3_268)
    }
    
}


// MARK: - Private
typealias Form = Set<Character>

private func _parse(_ lines: [String]) -> [[Form]] {
    return lines.split(separator: "").map { group in
        group.map { Set($0) }
    }
}

private func _collateAll(_ groups: [[Form]]) -> [Form] {
    return groups.map { group in
        group.reduce(Form()) { result, element in
            return result.union(element)
        }
    }
}

private func _collateCommon(_ groups: [[Form]]) -> [Form] {
    return groups.map { group in
        group.dropFirst().reduce(group.first!) { result, element in
            return result.intersection(element)
        }
    }
}
