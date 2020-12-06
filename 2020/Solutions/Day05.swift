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
        let boardingPasses = [
            "BFFFBBFRRR",
            "FFFBBBFRRR",
            "BBFFBBFRLL"
        ]
        let seatIDs = boardingPasses.compactMap { _seatID(for: $0) }
        XCTAssertEqual(seatIDs.reduce(0, max), 820)
    }
    
    func test_solution() {
        let boardingPasses = TestHarnessInput("input05.txt")!
        let seatIDs = boardingPasses.compactMap { _seatID(for: $0) }
        XCTAssertEqual(seatIDs.reduce(0, max), 883)
        
        let sortedIDs = seatIDs.sorted()
        let adjcacentIDs = zip(sortedIDs, Array(sortedIDs.dropFirst()))
        let (firstGap, _) = adjcacentIDs.first { $0.0 + 1 < $0.1 }!
        XCTAssertEqual(firstGap + 1, 532)
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
