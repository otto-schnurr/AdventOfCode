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

    func test_examples() {
        var adapters = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
        var differences = _differences(for: adapters)
        var answer =
            differences.filter { $0 == 1 }.count *
            (differences.filter { $0 == 3 }.count)
        XCTAssertEqual(answer, 35)
        
        adapters = [
            28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19,
            38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3
        ]
        differences = _differences(for: adapters)
        answer =
            differences.filter { $0 == 1 }.count *
            (differences.filter { $0 == 3 }.count)
        XCTAssertEqual(answer, 220)
    }

    func test_solution() {
        let adapters = TestHarnessInput("input10.txt")!.compactMap { Int($0) }
        let differences = _differences(for: adapters)
        let answer =
            differences.filter { $0 == 1 }.count *
            (differences.filter { $0 == 3 }.count)
        XCTAssertEqual(answer, 2_592)
    }
    
}


// MARK: - Private
private func _differences(for adapters: [Int]) -> [Int] {
    let sorted = [ 0 ] + adapters.sorted()
    return zip(sorted, sorted.dropFirst()).map { $0.1 - $0.0 } + [ 3 ]
}
