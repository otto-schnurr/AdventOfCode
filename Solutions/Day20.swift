//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day20.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/20
//  Created by Otto Schnurr on 1/23/2020.
//

import XCTest
import AdventOfCode

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false
private let _backgroundValue = Pixel.Value("#")

final class Day20: XCTestCase {
    
    func test_solutions() {
        guard _enableAllTests else { return }
        let map = _makeMap()
        XCTAssertEqual(map.gridWidth, 127)
        XCTAssertEqual(map.gridHeight, 129)
    }
    
}


// MARK: - Private Terrain Implementation
private func _makeMap() -> Grid {
    let pixelValues = try! TestHarnessInput("input20.txt").map({ Array($0) })
    return Grid(pixelValues: pixelValues, backgroundValue: _backgroundValue)
}
