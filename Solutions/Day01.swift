//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day01.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest

final class Day01: XCTestCase {
    
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

    private var lines = try! TestHarnessInput("input01.txt")
}
