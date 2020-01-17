//
//  Day19.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day19: XCTestCase {
    
    func test_solutions() {
        let computer = Computer()
        var count = 0
        
        for x in 0 ..< 50 {
            for y in 0 ..< 50 {
                if computer.valueAt(x, y) { count += 1 }
            }
        }
        
        XCTAssertEqual(count, 231)
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input19.txt")!

private extension Computer {
    
    func valueAt(_ x: Int, _ y: Int) -> Bool {
        load(_program)
        inputBuffer = [x, y]
        run()
        return harvestOutput()[0] != 0
    }
    
}
