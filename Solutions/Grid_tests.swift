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
    
    func test_differentPixels_areNotEqual() {
        let pixelA = Pixel(gridPosition: .zero, value: ".")
        let pixelB = Pixel(gridPosition: .zero, value: "#")
        let pixelC = Pixel(gridPosition: .zero, value: ".")

        XCTAssertEqual(pixelA, pixelA)
        XCTAssertNotEqual(pixelA, pixelB)
        XCTAssertNotEqual(pixelA, pixelC)
        XCTAssertNotEqual(pixelB, pixelC)
    }
    
    func test_emptyGrid_hasExpectedProperties() {
        let emptyGrid = Grid()
        XCTAssertEqual(emptyGrid.gridOrigin, .zero)
        XCTAssertEqual(emptyGrid.gridWidth, 0)
        XCTAssertEqual(emptyGrid.gridHeight, 0)
        XCTAssertFalse(emptyGrid.diagonalsAllowed)
        XCTAssertEqual(emptyGrid.nodes, [ ])
    }
    
    func test_minimalGrid_hasExpectedProperies() {
        let grid = Grid(
            fromGridStartingAt: .zero, width: 1, height: 1,
            diagonalsAllowed: false, nodeClass: Pixel.self
        )
        XCTAssertEqual(grid.gridOrigin, .zero)
        XCTAssertEqual(grid.gridWidth, 1)
        XCTAssertEqual(grid.gridHeight, 1)
        XCTAssertFalse(grid.diagonalsAllowed)
        XCTAssertEqual(grid.pixels?.map { $0.value }, [" "])
    }

    func test_typicalGrid_hasExpectedProperties() {
        let pixels = [
            Pixel(gridPosition: Grid.Position(1, 0), value: "X"),
            Pixel(gridPosition: Grid.Position(2, 0), value: "#"),
            Pixel(gridPosition: Grid.Position(3, 0), value: "O"),
            
            Pixel(gridPosition: Grid.Position(1, 2), value: "X"),
            Pixel(gridPosition: Grid.Position(2, 2), value: "#"),
            Pixel(gridPosition: Grid.Position(3, 2), value: "X"),
        ]
        let grid = Grid(pixels: pixels)
        
        XCTAssertEqual(grid.gridOrigin, Grid.Position(1, 0))
        XCTAssertEqual(grid.gridWidth, 3)
        XCTAssertEqual(grid.gridHeight, 3)
        XCTAssertFalse(grid.diagonalsAllowed)
        XCTAssertEqual(grid.pixels?.count, 9)
    }
    
}
