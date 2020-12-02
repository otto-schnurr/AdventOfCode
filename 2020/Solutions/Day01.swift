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

import Algorithms
import XCTest

final class Day01: XCTestCase {

    func test_example() {
        let expenses = [1721, 979, 366, 299, 675, 1456]
        
        var combination = expenses.firstCombination(ofCount: 2, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1], 514_579)

        combination = expenses.firstCombination(ofCount: 3, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1] * combination[2], 241_861_950)
    }
    
    func test_solution() {
        let expenses = Array(Input())
        
        var combination = expenses.firstCombination(ofCount: 2, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1], 858_496)

        combination = expenses.firstCombination(ofCount: 3, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1] * combination[2], 263_819_430)
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

private extension Array where Element == Int {
    func firstCombination(ofCount count: Int, summingTo sum: Int) -> [Int]? {
        // optimization: Large values are too big to combine with each other.
        //               (Assuming all values are positive.)
        let threshold = sum / 2
        let smallValues = filter { $0 <= threshold }
        let largeValues = filter { $0 > threshold }

        return largeValues.lazy.map { largeValue in
            smallValues + [largeValue]
        }.compactMap {
            $0.combinations(ofCount: count).first(summingTo: sum)
        }.first
    }
}

private extension Combinations where Base == [Int] {
    func first(summingTo sum: Int) -> Element? {
        return first { $0.reduce(0, +) == sum }
    }
}
