//
//  Combinatorics_tests.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/14/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

class Combinatorics_tests: XCTestCase {

    func test_permutationsOfEmptyArray_isEmpty() {
        XCTAssertEqual([Int]().permutations, [[Int]]())
    }
    
    func test_permutationsOfSingleElementArray_isItself() {
        XCTAssertEqual(["foo"].permutations, [["foo"]])
    }
    
    func test_permutationsOfTwoElementArray_hasExpectedResults() {
        XCTAssertEqual(
            ["foo", "bar"].permutations,
            [["foo", "bar"], ["bar", "foo"]]
        )
    }

    func test_permutationsOfThreeElementArray_hasExpectedResults() {
        XCTAssertEqual(
            ["foo", "bar", "dog"].permutations,
            [
                ["foo", "bar", "dog"],
                ["bar", "foo", "dog"],
                ["dog", "bar", "foo"],
                ["bar", "dog", "foo"],
                ["foo", "dog", "bar"],
                ["dog", "foo", "bar"]
            ]
        )
    }
    
    func test_fiveElementArray_hasExpectedNumberOfPermutations() {
        XCTAssertEqual(Array((1...5)).permutations.count, 120)
    }
    
    func test_values_haveExpectedLowestCommonMultiples() {
        XCTAssertEqual(Combinatorics.lcm(1, 1), 1)

        XCTAssertEqual(Combinatorics.lcm(1, 2), 2)
        XCTAssertEqual(Combinatorics.lcm(2, 4), 4)
        XCTAssertEqual(Combinatorics.lcm(3, 7), 21)

        XCTAssertEqual(Combinatorics.lcm(2, 1), 2)
        XCTAssertEqual(Combinatorics.lcm(4, 2), 4)
        XCTAssertEqual(Combinatorics.lcm(7, 3), 21)
    }

}
