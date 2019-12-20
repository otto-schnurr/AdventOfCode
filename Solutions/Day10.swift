//
//  Day10.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/18/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day10: XCTestCase {
    
    func test_coordinateArithmetic() {
        let unit = Coordinate(1, 1)
        
        XCTAssertEqual(0 * unit, .zero)
        XCTAssertEqual(3 * Coordinate.zero, .zero)
        XCTAssertEqual(-1 * unit, Coordinate(-1, -1))

        XCTAssertEqual(unit * 0, .zero)
        XCTAssertEqual(Coordinate.zero * 3, .zero)
        XCTAssertEqual(unit * -1, Coordinate(-1, -1))
        
        XCTAssertEqual(unit + unit, Coordinate(2, 2))
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
    
    func test_interiorCoordinates() {
        let unit = Coordinate(1, 1)
        
        XCTAssertEqual(
            Array(InteriorCoordinates(between: .zero, and: .zero)),
            [ ]
        )
        XCTAssertEqual(
            Array(InteriorCoordinates(between: unit, and: unit)),
            [ ]
        )
        XCTAssertEqual(
            Array(InteriorCoordinates(between: .zero, and: unit)),
            [ ]
        )
        XCTAssertEqual(
            Array(InteriorCoordinates(between: unit, and: .zero)),
            [ ]
        )
    }
    
    func test_coordinateParsing() {
        let map = """
        .#..#
        .....
        ...##
        """
        
        XCTAssertEqual(
            [Coordinate](from: map),
            [Coordinate(0, 1), Coordinate(0, 4), Coordinate(2, 3), Coordinate(2, 4)]
        )
    }
    
}


// MARK: - Private
private struct Coordinate: Equatable {

    static let zero = Coordinate(0, 0)

    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

}

private extension Coordinate {
    
    var reduced: Coordinate {
        guard self != .zero else { return self }
        let divisor = gcd(abs(x), abs(y))
        return Coordinate(x/divisor, y/divisor)
    }

    static func *(_ factor: Int, coordinate: Coordinate) -> Coordinate {
        return Coordinate(factor * coordinate.x, factor * coordinate.y)
    }
    
    static func *(coordinate: Coordinate, _ factor: Int) -> Coordinate {
        return factor * coordinate
    }
    
    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(lhs.x + rhs.x, lhs.x + rhs.y)
    }
    
}

extension Coordinate: CustomStringConvertible {
    var description: String { return "(\(x), \(y))" }
}

private struct InteriorCoordinates: Sequence, IteratorProtocol {
    
    init(between a: Coordinate, and b: Coordinate) {
        
    }
    
    mutating func next() -> Coordinate? {
        // !!!: implement me
        return nil
    }
    
}

extension Array where Element == Coordinate {
    
    init(from map: String) {
        var result = [Coordinate]()

        for (x, row) in map.split(separator: "\n").enumerated() {
            for (y, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.append(Coordinate(x, y))
            }
        }
        
        self = result
    }
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
