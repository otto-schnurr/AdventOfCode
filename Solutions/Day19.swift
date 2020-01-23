//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day19.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/19
//  Created by Otto Schnurr on 12/28/2019.
//

import XCTest
import AdventOfCode

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false

final class Day19: XCTestCase {
    
    func test_solutions() {
        let computer = Computer()
        var count = 0
        var display = Grid.PixelData()
        
        for x in 0 ..< 50 {
            for y in 0 ..< 50 {
                let position = Position(x, y)
                if computer.value(at: position) {
                    display[position] = "#"
                    count += 1
                }
            }
        }
        
        Grid(data: display).render(backgroundValue: ".")
        XCTAssertEqual(count, 231)
        
        guard _enableAllTests else { return }
        
        // HACK: Get us close to save some convergence time.
        var corner = Position(500, 400)
        var span = computer.spanBack(from: corner)
        
        while span.horizontal != 100 || span.vertical != 100 {
            corner = corner &+ Position(100 - span.horizontal, 100 - span.vertical)
            span = computer.spanBack(from: corner)
            print("span from \(corner): \(span)")
        }

        XCTAssertEqual(corner, Position(1020, 844))
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input19.txt")!

private extension Computer {
    
    func value(at position: Position) -> Bool {
        load(_program)
        inputBuffer = [Word(position.x), Word(position.y)]
        run()
        return harvestOutput()[0] != 0
    }
    
    /// - Parameter corner:
    ///   The lower right corner to measure the span from/
    ///
    /// - Returns: The length of contiguously true values,
    ///   both horizontally and vertically from corner to the origin.
    func spanBack(from corner: Position) -> (horizontal: Int, vertical: Int) {
        var span = (horizontal: 0, vertical: 0)
        guard corner.x >= 0 && corner.y >= 0 else { return span }
        
        for x in (0 ... corner.x).reversed() {
            guard value(at: Position(x, corner.y)) else { break }
            span.horizontal += 1
        }
        
        for y in (0 ... corner.y).reversed() {
            guard value(at: Position(corner.x, y)) else { break }
            span.vertical += 1
        }
        
        return span
    }
    
}
