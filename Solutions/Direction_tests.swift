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
    
    func test_turns() {
        XCTAssertEqual(Direction.north.turned(.left), .west)
        XCTAssertEqual(Direction.north.turned(.right), .east)
        
        XCTAssertEqual(Direction.east.turned(.left), .north)
        XCTAssertEqual(Direction.east.turned(.right), .south)
        
        XCTAssertEqual(Direction.south.turned(.left), .east)
        XCTAssertEqual(Direction.south.turned(.right), .west)
        
        XCTAssertEqual(Direction.west.turned(.left), .south)
        XCTAssertEqual(Direction.west.turned(.right), .north)
    }

}
