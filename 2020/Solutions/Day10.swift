//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day10.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/10
//  Created by Otto Schnurr on 12/10/2020.
//

import Algorithms
import XCTest

final class Day10: XCTestCase {

    func test_example() {
        let adapters = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
        let differences = _differences(for: adapters)
        let answer =
            differences.filter { $0 == 1 }.count *
            (differences.filter { $0 == 3 }.count)
        XCTAssertEqual(answer, 35)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
private func _differences(for adapters: [Int]) -> [Int] {
    let sorted = [ 0 ] + adapters.sorted()
    return zip(sorted, sorted.dropFirst()).map { $0.1 - $0.0 } + [ 3 ]
}
