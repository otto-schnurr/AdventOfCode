//
//  Grid_tests.swift
//  AdventOfCode-UnitTests
//
//  Created by Otto Schnurr on 1/18/2020.
//  Copyright © 2020 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

class Grid_tests: XCTestCase {
    
    func test_emptyGrid_hasExpectedProperties() {
        let emptyGrid = Grid()
        XCTAssertEqual(emptyGrid.gridOrigin, .zero)
        XCTAssertEqual(emptyGrid.gridWidth, 0)
        XCTAssertEqual(emptyGrid.gridHeight, 0)
        XCTAssertFalse(emptyGrid.diagonalsAllowed)
        XCTAssertEqual(emptyGrid.nodes, [ ])
    }
    
}
