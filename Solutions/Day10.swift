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
    
    func test_reduceCoordinate() {
        XCTAssertEqual(Coordinate.zero.reduced, .zero)
        
        XCTAssertEqual(Coordinate(1, 0).reduced, Coordinate(1, 0))
        XCTAssertEqual(Coordinate(2, 0).reduced, Coordinate(1, 0))
        XCTAssertEqual(Coordinate(5, 0).reduced, Coordinate(1, 0))
        
        XCTAssertEqual(Coordinate(0, 1).reduced, Coordinate(0, 1))
        XCTAssertEqual(Coordinate(0, 2).reduced, Coordinate(0, 1))
        XCTAssertEqual(Coordinate(0, 5).reduced, Coordinate(0, 1))
        
        XCTAssertEqual(Coordinate(1, 1).reduced, Coordinate(1, 1))
        XCTAssertEqual(Coordinate(2, 2).reduced, Coordinate(1, 1))
        XCTAssertEqual(Coordinate(5, 5).reduced, Coordinate(1, 1))

        XCTAssertEqual(Coordinate(1, 2).reduced, Coordinate(1, 2))
        XCTAssertEqual(Coordinate(2, 4).reduced, Coordinate(1, 2))
        XCTAssertEqual(Coordinate(5, 10).reduced, Coordinate(1, 2))

        XCTAssertEqual(Coordinate(-5, 0).reduced, Coordinate(-1, 0))
        XCTAssertEqual(Coordinate(0, -5).reduced, Coordinate(0, -1))
        XCTAssertEqual(Coordinate(-5, 5).reduced, Coordinate(-1, 1))
        XCTAssertEqual(Coordinate(5, -5).reduced, Coordinate(1, -1))
        XCTAssertEqual(Coordinate(-5, -5).reduced, Coordinate(-1, -1))
    }
    
}


// MARK: - Private
private struct Coordinate: Equatable {

    static let zero = Coordinate(0, 0)

    let x: Int
    let y: Int
    
    var reduced: Coordinate {
        guard self != .zero else { return self }
        let divisor = gcd(abs(x), abs(y))
        return Coordinate(x/divisor, y/divisor)
    }

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

// reference: https://github.com/raywenderlich/swift-algorithm-club
private func gcd(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}
