//
//  Array+Permutations_tests.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/14/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Array_Permutations_tests: XCTestCase {

    func test_permutationsOfEmptyArray_isEmpty() {
        XCTAssertEqual([Int]().permutations, [[Int]]())
    }
}
