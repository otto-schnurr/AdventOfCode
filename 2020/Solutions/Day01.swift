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

    func test_example_1() {
        let expenses = [1721, 979, 366, 299, 675, 1456]
        let pair = expenses.firstPairThatAdds(to: 2020)!
        XCTAssertEqual(pair.0 * pair.1, 514579)
    }
    
    func test_solution() {
        let expenses = Array(Input())
        let pair = expenses.firstPairThatAdds(to: 2020)!
        XCTAssertEqual(pair.0 * pair.1, 858496)
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

    func firstPairThatAdds(to sum: Int) -> (Int, Int)? {
        let pairs = combinations(ofCount: 2)
        if let result = pairs.first(where: { $0[0] + $0[1] == sum }) {
            return (result[0], result[1])
        } else {
            return nil
        }
    }

}
