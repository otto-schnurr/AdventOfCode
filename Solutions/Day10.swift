//
//  Day10.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/18/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day10: XCTestCase {
    
    func test_coordinateParsing() {
        let map = """
        .#..#
        .....
        ...##
        """
        
        XCTAssertEqual(
            parseCoordinates(from: map),
            [Coordinate(0, 1), Coordinate(0, 4), Coordinate(2, 3), Coordinate(2, 4)]
        )
    }
    
}


// MARK: - Private
private struct Coordinate: Equatable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String { return "(\(x), \(y))" }
}

private func parseCoordinates(from map: String) -> [Coordinate] {
    var result = [Coordinate]()

    for (x, row) in map.split(separator: "\n").enumerated() {
        for (y, _) in row.enumerated().filter({ $0.element == "#" }) {
            result.append(Coordinate(x, y))
        }
    }
    
    return result
}
