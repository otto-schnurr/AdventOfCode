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
        var expenses = [1721, 979, 366, 299, 675, 1456]
        
        var combination = expenses.firstCombination(ofCount: 2, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1], 514579)

        combination = expenses.firstCombination(ofCount: 3, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1] * combination[2], 241861950)
    }
    
    func test_solution() {
        var expenses = Array(Input())
        
        var combination = expenses.firstCombination(ofCount: 2, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1], 858496)

        combination = expenses.firstCombination(ofCount: 3, summingTo: 2020)!
        XCTAssertEqual(combination[0] * combination[1] * combination[2], 263819430)
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
    mutating func firstCombination(ofCount count: Int, summingTo sum: Int) -> [Int]? {
        // optimization: Values above this threshold are too big to combine with each other.
        let index = partition { $0 > sum / 2 }
        let smallValues = Array(self[0 ..< index])
        let smallCombinations = smallValues.combinations(ofCount: count)

        if let result = smallCombinations.first(summingTo: sum) { return result }

        for largeValue in self[index ..< endIndex] {
            let collection = smallValues + [largeValue]
            let combinations = collection.combinations(ofCount: count)
            
            if let result = combinations.first(summingTo: sum) { return result }
        }

        return nil
    }
}

private extension Combinations where Base == [Int] {
    func first(summingTo sum: Int) -> Element? {
        return first { $0.reduce(0, +) == sum }
    }
}
