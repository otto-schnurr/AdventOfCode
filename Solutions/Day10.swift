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
        XCTAssertEqual(unit - unit, .zero)
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
        XCTAssertEqual(
            Array(InteriorCoordinates(between: .zero, and: 4 * unit)),
            [ unit, 2 * unit, 3 * unit ]
        )
        XCTAssertEqual(
            Array(InteriorCoordinates(between: 4 * unit, and: .zero)),
            [ 3 * unit, 2 * unit, unit ]
        )
        XCTAssertEqual(
            Array(InteriorCoordinates(between: Coordinate(0, 1), and: Coordinate(0, 4))),
            [ Coordinate(0, 2), Coordinate(0, 3) ]
        )
    }
    
    func test_coordinateAngles() {
        XCTAssertEqual(Coordinate.zero.angle, 0)
        XCTAssertEqual(Coordinate(0, +1).angle, 0, accuracy: 0.001)
        XCTAssertEqual(Coordinate(+1, +1).angle, CGFloat.pi / 4, accuracy: 0.001)
        XCTAssertEqual(Coordinate(+1, 0).angle, CGFloat.pi / 2, accuracy: 0.001)
        XCTAssertEqual(Coordinate(+1, -1).angle, 3 * CGFloat.pi / 4, accuracy: 0.001)
        XCTAssertEqual(Coordinate(0, -1).angle, CGFloat.pi, accuracy: 0.001)
        XCTAssertEqual(Coordinate(-1, -1).angle, 5 * CGFloat.pi / 4, accuracy: 0.001)
        XCTAssertEqual(Coordinate(-1, 0).angle, 3 * CGFloat.pi / 2, accuracy: 0.001)
        XCTAssertEqual(Coordinate(-1, +1).angle, 7 * CGFloat.pi / 4, accuracy: 0.001)
    }
    
    func test_coordinateParsing() {
        let map = """
        .#..#
        .....
        ...##
        """
        
        XCTAssertEqual(
            [Coordinate](from: map),
            [Coordinate(1, 0), Coordinate(4, 0), Coordinate(3, 2), Coordinate(4, 2)]
        )
    }
            
    func test_examples() {
        var map = """
        .#..#
        .....
        #####
        ....#
        ...##
        """
        var coordinates = [Coordinate](from: map)
        XCTAssertEqual(coordinates.visiblityCounts.max()!, 8)
        
        map = """
        ......#.#.
        #..#.#....
        ..#######.
        .#.#.###..
        .#..#.....
        ..#....#.#
        #..#....#.
        .##.#..###
        ##...#..#.
        .#....####
        """
        coordinates = [Coordinate](from: map)
        XCTAssertEqual(coordinates.visiblityCounts.max()!, 33)
        
        map = """
        #.#...#.#.
        .###....#.
        .#....#...
        ##.#.#.#.#
        ....#.#.#.
        .##..###.#
        ..#...##..
        ..##....##
        ......#...
        .####.###.
        """
        coordinates = [Coordinate](from: map)
        XCTAssertEqual(coordinates.visiblityCounts.max()!, 35)
        
        map = """
        .#..#..###
        ####.###.#
        ....###.#.
        ..###.##.#
        ##.##.#.#.
        ....###..#
        ..#.#..#.#
        #..#.#.###
        .##...##.#
        .....#.#..
        """
        coordinates = [Coordinate](from: map)
        XCTAssertEqual(coordinates.visiblityCounts.max()!, 41)
        
        map = """
        .#..##.###...#######
        ##.############..##.
        .#.######.########.#
        .###.#######.####.#.
        #####.##.#.##.###.##
        ..#####..#.#########
        ####################
        #.####....###.#.#.##
        ##.#################
        #####.##.###..####..
        ..######..##.#######
        ####.##.####...##..#
        .#####..#.######.###
        ##...#.##########...
        #.##########.#######
        .####.#.###.###.#.##
        ....##.##.###..#####
        .#.#.###########.###
        #.#.#.#####.####.###
        ###.##.####.##.#..##
        """
        coordinates = [Coordinate](from: map)
        XCTAssertEqual(coordinates.visiblityCounts.max()!, 210)
    }
    
    func test_solution() {
        let coordinates = [Coordinate](from: _map)
        XCTAssertEqual(coordinates.visiblityCounts.max()!, 309)
    }
    
}


// MARK: - Private Implementation
private struct Coordinate: Equatable, Hashable {

    static let zero = Coordinate(0, 0)

    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

}

private extension Coordinate {
    
    var angle: CGFloat {
        let result = atan2(CGFloat(x), CGFloat(y))
        return result >= 0 ? result : result + 2 * .pi
    }
    
    var reduced: Coordinate {
        guard self != .zero else { return self }
        let divisor = gcd(abs(x), abs(y))
        return Coordinate(x/divisor, y/divisor)
    }

    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    static func *(_ factor: Int, coordinate: Coordinate) -> Coordinate {
        return Coordinate(factor * coordinate.x, factor * coordinate.y)
    }
    
    static func *(coordinate: Coordinate, _ factor: Int) -> Coordinate {
        return factor * coordinate
    }
    
}

extension Coordinate: CustomStringConvertible {
    var description: String { return "(\(x), \(y))" }
}

private struct InteriorCoordinates: Sequence, IteratorProtocol {
    
    init(between a: Coordinate, and b: Coordinate) {
        current = a
        step = (b - a).reduced
        target = b
    }
    
    mutating func next() -> Coordinate? {
        guard current != target else { return nil }
        current = current + step
        guard current != target else { return nil }
        return current
    }
    
    private var current: Coordinate
    private let step: Coordinate
    private let target: Coordinate
    
}

extension Array where Element == Coordinate {
    
    var visiblityCounts: [Int] {
        let fastCoordinates = Set(self)
        return self.map {
            visibility(from: $0, fastCoordinates: fastCoordinates)
        }
    }
    
    init(from map: String) {
        var result = [Coordinate]()

        for (y, row) in map.split(separator: "\n").enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.append(Coordinate(x, y))
            }
        }
        
        self = result
    }
    
    func visibility(
        from station: Coordinate, fastCoordinates: Set<Coordinate>
    ) -> Int {
        return self.filter { target in
            guard station != target else { return false }
            return InteriorCoordinates(between: station, and: target)
                .allSatisfy { return !fastCoordinates.contains($0) }
        }.count
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


// Private Input
private let _map = """
#.#................#..............#......#......
.......##..#..#....#.#.....##...#.........#.#...
.#...............#....#.##......................
......#..####.........#....#.......#..#.....#...
.....#............#......#................#.#...
....##...#.#.#.#.............#..#.#.......#.....
..#.#.........#....#..#.#.........####..........
....#...#.#...####..#..#..#.....#...............
.............#......#..........#...........#....
......#.#.........#...............#.............
..#......#..#.....##...##.....#....#.#......#...
...#.......##.........#.#..#......#........#.#..
#.............#..........#....#.#.....#.........
#......#.#................#.......#..#.#........
#..#.#.....#.....###..#.................#..#....
...............................#..........#.....
###.#.....#.....#.............#.......#....#....
.#.....#.........#.....#....#...................
........#....................#..#...............
.....#...#.##......#............#......#.....#..
..#..#..............#..#..#.##........#.........
..#.#...#.......#....##...#........#...#.#....#.
.....#.#..####...........#.##....#....#......#..
.....#..#..##...............................#...
.#....#..#......#.#............#........##...#..
.......#.....................#..#....#.....#....
#......#..###...........#.#....#......#.........
..............#..#.#...#.......#..#.#...#......#
.......#...........#.....#...#.............#.#..
..##..##.............#........#........#........
......#.............##..#.........#...#.#.#.....
#........#.........#...#.....#................#.
...#.#...........#.....#.........#......##......
..#..#...........#..........#...................
.........#..#.......................#.#.........
......#.#.#.....#...........#...............#...
......#.##...........#....#............#........
#...........##.#.#........##...........##.......
......#....#..#.......#.....#.#.......#.##......
.#....#......#..............#.......#...........
......##.#..........#..................#........
......##.##...#..#........#............#........
..#.....#.................###...#.....###.#..#..
....##...............#....#..................#..
.....#................#.#.#.......#..........#..
#........................#.##..........#....##..
.#.........#.#.#...#...#....#........#..#.......
...#..#.#......................#...............#
"""
