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
        let output = computer.harvestOutput()
        XCTAssertEqual(output.count, 2863)
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input17.txt")!
