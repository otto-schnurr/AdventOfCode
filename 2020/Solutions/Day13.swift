//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

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
        XCTAssertEqual(_timeForSequentialDeparture(for: lines[1]), 1_068_781)
    }

    func test_solution() {
        let lines = Array(TestHarnessInput("input13.txt")!)
        let timestamp = _timeStamp(for: lines)!
        let result = _nextDeparture(for: lines)!
        XCTAssertEqual((result.departure - timestamp) * result.busID, 5_257)
        XCTAssertEqual(_timeForSequentialDeparture(for: lines[1]), 538_703_333_547_789)
    }
    
}


// MARK: - Private
private func _timeStamp(for lines: [String]) -> Int? { return Int(lines[0]) }

private func _nextDeparture(for lines: [String]) -> (busID: Int, departure: Int)? {
    guard let timestamp = _timeStamp(for: lines) else { return nil }

    let busIDs = lines[1]
        .components(separatedBy: .punctuationCharacters)
        .compactMap { Int($0) }
    let pairs = busIDs
        .map { busID -> (busID: Int, departure: Int) in
            let nextDeparture = (timestamp / busID + 1) * busID
            return (busID: busID, departure: nextDeparture)
        }
    return pairs.min { $0.departure < $1.departure }
}

private func _timeForSequentialDeparture(for line: String) -> Int {
    let entries = line
        .components(separatedBy: .punctuationCharacters)
        .enumerated()
        .compactMap { (offset, element) -> (busID: Int, offset: Int)? in
            guard let busID = Int(element) else { return nil }
            return (busID: busID, offset: offset)
        }
    
    // reference: https://brilliant.org/wiki/chinese-remainder-theorem/
    let modulus = entries.reduce(1) { result, entry in result * entry.busID }
    
    let result = entries.reduce(0) { result, entry in
        let submodulus = modulus / entry.busID
        let remainder = (entry.busID - entry.offset)
        return result + remainder * submodulus * submodulus.inverseModulo(entry.busID)
    }
    
    return result % modulus
}

// reference: https://titanwolf.org/Network/Articles/Article?AID=605f4cc0-cdfa-4f40-a5a3-e7cc0f282c18
private extension BinaryInteger {

    func inverseModulo(_ mod: Self) -> Self {
        var (m, n) = (mod, self)
        var (x, y) = (Self(0), Self(1))

        while n != 0 {
            (x, y) = (y, x - (m/n) * y)
            (m, n) = (n, m % n)
        }

        while x < 0 {
            x += mod
        }

        return x
    }

}
