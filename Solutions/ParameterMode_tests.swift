//
//  ParameterMode_tests.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//

import XCTest
@testable import AdventOfCode

class ParameterMode_tests: XCTestCase {

    func test_parsingInvalidInput_producesNoModes() {
        XCTAssertEqual(ParameterMode.parse(count: -1, from: 0), [])
        XCTAssertEqual(ParameterMode.parse(count: 1, from: -1), [])
    }
    
    func test_parsingValidCounts_producesExpectedModes() {
        XCTAssertEqual(ParameterMode.parse(count: 0, from: 0), [])
        XCTAssertEqual(ParameterMode.parse(count: 1, from: 0), [])
        XCTAssertEqual(ParameterMode.parse(count: 2, from: 0), [])
        XCTAssertEqual(ParameterMode.parse(count: 3, from: 0), [])
        
        XCTAssertEqual(ParameterMode.parse(count: 0, from: 10), [])
        XCTAssertEqual(ParameterMode.parse(count: 1, from: 10), [.position])
        XCTAssertEqual(ParameterMode.parse(count: 2, from: 10), [.position, .position])
        XCTAssertEqual(ParameterMode.parse(count: 3, from: 10), [.position, .position, .position])
        
        XCTAssertEqual(ParameterMode.parse(count: 0, from: 100), [])
        XCTAssertEqual(ParameterMode.parse(count: 1, from: 100), [.immediate])
        XCTAssertEqual(ParameterMode.parse(count: 2, from: 100), [.immediate, .position])
        XCTAssertEqual(ParameterMode.parse(count: 3, from: 100), [.immediate, .position, .position])

        XCTAssertEqual(ParameterMode.parse(count: 0, from: 1000), [])
        XCTAssertEqual(ParameterMode.parse(count: 1, from: 1000), [.position])
        XCTAssertEqual(ParameterMode.parse(count: 2, from: 1000), [.position, .immediate])
        XCTAssertEqual(ParameterMode.parse(count: 3, from: 1000), [.position, .immediate, .position])
    }

}
