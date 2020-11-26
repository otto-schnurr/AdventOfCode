//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day01.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/1
//  Created by Otto Schnurr on 11/26/2020.
//

import XCTest

final class Day01: XCTestCase {

    // As a placeholder, this is a Day 1 solution from 2019.
    // TODO: Replace this with a Day 1 solution from 2020.
    func test_solution() {
        func fuel(for mass: Int) -> Int { return mass / 3 - 2 }

        func totalFuel(for mass: Int) -> Int {
            let f = fuel(for: mass)
            return f > 0 ? f + totalFuel(for: f) : 0
        }

        XCTAssertEqual(Input().map(fuel).reduce(0, +), 3563458)
        XCTAssertEqual(Input().map(totalFuel).reduce(0, +), 5342292)
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

