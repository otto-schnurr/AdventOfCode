//
//  Direction_tests.swift
//  AdventOfCode-UnitTests
//
//  Created by Otto Schnurr on 12/31/19.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Direction_tests: XCTestCase {
    
    func test_allDirections_accountedFor() {
        XCTAssertEqual(Direction.all.count, 4)
    }
    
}
