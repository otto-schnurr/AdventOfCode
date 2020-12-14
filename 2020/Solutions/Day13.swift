//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day13.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/13
//  Created by Otto Schnurr on 12/13/2020.
//

import XCTest

final class Day13: XCTestCase {

    func test_examples() {
        let lines = """
        939
        7,13,x,x,59,x,31,19
        """.components(separatedBy: .newlines)
        let timestamp = _timeStamp(for: lines)!
        let result = _nextDeparture(for: lines)!
        XCTAssertEqual((result.departure - timestamp) * result.busID, 295)
    }

    func test_solution() {
        let lines = Array(TestHarnessInput("input13.txt")!)
        let timestamp = _timeStamp(for: lines)!
        let result = _nextDeparture(for: lines)!
        XCTAssertEqual((result.departure - timestamp) * result.busID, 5_257)
    }
    
}


// MARK: - Private
private func _timeStamp(for lines: [String]) -> Int? { return Int(lines[0]) }

private func _nextDeparture(for lines: [String]) -> (busID: Int, departure: Int)? {
    guard let timestamp = _timeStamp(for: lines) else { return nil }

    let busIDs = lines[1]
        .components(separatedBy: .punctuationCharacters)
        .filter { $0 != "x" }
        .compactMap { Int($0) }
    let pairs = busIDs
        .map { busID -> (busID: Int, departure: Int) in
            let nextDeparture = (timestamp / busID + 1) * busID
            return (busID: busID, departure: nextDeparture)
        }
    return pairs.min { $0.departure < $1.departure }
}
