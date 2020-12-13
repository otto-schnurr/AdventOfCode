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

import Algorithms
import XCTest

final class Day13: XCTestCase {

    func test_examples() {
        let lines = """
        939
        7,13,x,x,59,x,31,19
        """.components(separatedBy: .newlines)
        let timestamp = Int(lines[0])!
        let busIDs = lines[1]
            .components(separatedBy: .punctuationCharacters)
            .filter { $0 != "x" }
            .compactMap { Int($0) }
        let pairs = busIDs
            .map { busID -> (busID: Int, departure: Int) in
                let nextDeparture = (timestamp / busID + 1) * busID
                return (busID: busID, departure: nextDeparture)
            }
        let bestPair = pairs
            .min { $0.departure < $1.departure }!
        XCTAssertEqual((bestPair.departure - 939) * bestPair.busID, 295)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
