//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day01.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/1
//  Created by Otto Schnurr on 12/2/2020.
//

import XCTest
import Algorithms

final class Day01: XCTestCase {

    func test_example() {
        let depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
        let count = depths.adjacentPairs().filter { $0 < $1 }.count
        XCTAssertEqual(count, 7)
    }

    func test_solution() {
        let depths = Array(Input())
        let count = depths.adjacentPairs().filter { $0 < $1 }.count
        XCTAssertEqual(count, 1791)
    }

}


// MARK: - Private
private struct Input: Sequence, IteratorProtocol {
    
    mutating func next() -> Int? {
        guard let line = lines.next() else { return nil }
        return Int(line)
    }

    private var lines = TestHarnessInput("input01.txt")!

}
