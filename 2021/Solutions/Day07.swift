//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day07.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/7
//  Created by Otto Schnurr on 12/11/2020.
//

import XCTest

final class Day07: XCTestCase {

    func test_example() {
        let data = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
        let median = data.sorted()[data.count / 2]
        let deviation = data.map { abs($0 - median) }
        XCTAssertEqual(deviation.reduce(0, +), 37)
    }
    
    func test_solution() {
        let line = Array(TestHarnessInput("input07.txt")!).first!
        let data = line.split(separator: ",").compactMap { Int(String($0)) }
        let median = data.sorted()[data.count / 2]
        let deviation = data.map { abs($0 - median) }
        XCTAssertEqual(deviation.reduce(0, +), 323_647)
    }

}
