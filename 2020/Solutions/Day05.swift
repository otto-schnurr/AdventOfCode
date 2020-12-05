//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day05.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/5
//  Created by Otto Schnurr on 12/5/2020.
//

import XCTest

final class Day05: XCTestCase {

    func test_example() {
        let seatIDs = [
            "BFFFBBFRRR",
            "FFFBBBFRRR",
            "BBFFBBFRLL"
        ].compactMap { _seatID(for: $0) }
        XCTAssertEqual(seatIDs.reduce(0, max), 820)
    }
    
    func test_solution() {
    }
    
}


// MARK: - Private
private func _seatID(for boardingPass: String) -> Int? {
    let characters = boardingPass.map { (c: Character) -> Character in
        switch c {
        case "F", "L": return "0"
        case "B", "R": return "1"
        default: return c
        }
    }
    let binaryString = String(characters)
    return Int(binaryString, radix: 2)
}
