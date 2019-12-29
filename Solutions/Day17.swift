//
//  Day17.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day17: XCTestCase {
    
    func test_solutions() {
        let computer = Computer()
        computer.load(_program)
        computer.run()
        let output = computer.harvestOutput().map { Character(UnicodeScalar($0)!) }

        let screen = Screen(pixels: output.split(separator: "\n").map { Array($0) })!
        XCTAssertEqual(screen.width, 53)
        XCTAssertEqual(screen.height, 53)
        
        screen.render()
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input17.txt")!
