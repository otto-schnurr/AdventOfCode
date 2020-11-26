//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day10.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/10
//  Created by Otto Schnurr on 12/18/2019.
//

import XCTest
import AdventOfCode

final class Day10: XCTestCase {
    
    func test_positionArithmetic() {
        let unit = Position.one
        
        XCTAssertEqual(0 &* unit, .zero)
        XCTAssertEqual(3 &* Position.zero, .zero)
        XCTAssertEqual(-1 &* unit, Position(-1, -1))

        XCTAssertEqual(unit &* 0, .zero)
        XCTAssertEqual(Position.zero &* 3, .zero)
        XCTAssertEqual(unit &* -1, Position(-1, -1))
        
        XCTAssertEqual(unit &+ unit, Position(2, 2))
        XCTAssertEqual(unit &- unit, .zero)
    }
    
    func test_reducePosition() {
        XCTAssertEqual(Position.zero.reduced, .zero)
        
        XCTAssertEqual(Position(1, 0).reduced, Position(1, 0))
        XCTAssertEqual(Position(2, 0).reduced, Position(1, 0))
        XCTAssertEqual(Position(5, 0).reduced, Position(1, 0))
        
        XCTAssertEqual(Position(0, 1).reduced, Position(0, 1))
        XCTAssertEqual(Position(0, 2).reduced, Position(0, 1))
        XCTAssertEqual(Position(0, 5).reduced, Position(0, 1))
        
        XCTAssertEqual(Position(1, 1).reduced, Position(1, 1))
        XCTAssertEqual(Position(2, 2).reduced, Position(1, 1))
        XCTAssertEqual(Position(5, 5).reduced, Position(1, 1))

        XCTAssertEqual(Position(1, 2).reduced, Position(1, 2))
        XCTAssertEqual(Position(2, 4).reduced, Position(1, 2))
        XCTAssertEqual(Position(5, 10).reduced, Position(1, 2))

        XCTAssertEqual(Position(-5, 0).reduced, Position(-1, 0))
        XCTAssertEqual(Position(0, -5).reduced, Position(0, -1))
        XCTAssertEqual(Position(-5, 5).reduced, Position(-1, 1))
        XCTAssertEqual(Position(5, -5).reduced, Position(1, -1))
        XCTAssertEqual(Position(-5, -5).reduced, Position(-1, -1))
    }
    
    func test_interiorPositions() {
        let unit = Position(1, 1)
        
        XCTAssertEqual(
            Array(InteriorPositions(between: .zero, and: .zero)),
            [ ]
        )
        XCTAssertEqual(
            Array(InteriorPositions(between: unit, and: unit)),
            [ ]
        )
        XCTAssertEqual(
            Array(InteriorPositions(between: .zero, and: unit)),
            [ ]
        )
        XCTAssertEqual(
            Array(InteriorPositions(between: unit, and: .zero)),
            [ ]
        )
        XCTAssertEqual(
            Array(InteriorPositions(between: .zero, and: 4 &* unit)),
            [ unit, 2 &* unit, 3 &* unit ]
        )
        XCTAssertEqual(
            Array(InteriorPositions(between: 4 &* unit, and: .zero)),
            [ 3 &* unit, 2 &* unit, unit ]
        )
        XCTAssertEqual(
            Array(InteriorPositions(between: Position(0, 1), and: Position(0, 4))),
            [ Position(0, 2), Position(0, 3) ]
        )
    }
    
    func test_positionAngles() {
        XCTAssertEqual(Position.zero.angle, 0)
        XCTAssertEqual(Position(0, -1).angle, 0, accuracy: 0.001)
        XCTAssertEqual(Position(+1, -1).angle, CGFloat.pi / 4, accuracy: 0.001)
        XCTAssertEqual(Position(+1, 0).angle, CGFloat.pi / 2, accuracy: 0.001)
        XCTAssertEqual(Position(+1, +1).angle, 3 * CGFloat.pi / 4, accuracy: 0.001)
        XCTAssertEqual(Position(0, +1).angle, CGFloat.pi, accuracy: 0.001)
        XCTAssertEqual(Position(-1, +1).angle, 5 * CGFloat.pi / 4, accuracy: 0.001)
        XCTAssertEqual(Position(-1, 0).angle, 3 * CGFloat.pi / 2, accuracy: 0.001)
        XCTAssertEqual(Position(-1, -1).angle, 7 * CGFloat.pi / 4, accuracy: 0.001)
    }
    
    func test_positionParsing() {
        let map = """
        .#..#
        .....
        ...##
        """
        
        XCTAssertEqual(
            [Position](from: map),
            [Position(1, 0), Position(4, 0), Position(3, 2), Position(4, 2)]
        )
    }
    
    func test_positionSorting() {
        let map = """
        #.#
        ...
        #.#
        """
        let positions = [Position](from: map)
        
        XCTAssertEqual(
            positions.sorted(around: .zero),
            [ Position(2, 0), Position(2, 2), Position(0, 2) ]
        )
        XCTAssertEqual(
            positions.sorted(around: Position(2, 0)),
            [ Position(2, 2), Position(0, 2), .zero ]
        )
        XCTAssertEqual(
            positions.sorted(around: Position(2, 2)),
            [ Position(2, 0), Position(0, 2), .zero ]
        )
        XCTAssertEqual(
            positions.sorted(around: Position(0, 2)),
            [ .zero, Position(2, 0), Position(2, 2) ]
        )
        XCTAssertEqual(
            positions.sorted(around: Position(1, 1)),
            [ Position(2, 0), Position(2, 2), Position(0, 2), .zero ]
        )
    }
    
    func test_examples_part1() {
        var map = """
        .#..#
        .....
        #####
        ....#
        ...##
        """
        var positions = [Position](from: map)
        XCTAssertEqual(positions.visiblityCounts.max()!, 8)
        
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
        positions = [Position](from: map)
        XCTAssertEqual(positions.visiblityCounts.max()!, 33)
        
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
        positions = [Position](from: map)
        XCTAssertEqual(positions.visiblityCounts.max()!, 35)
        
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
        positions = [Position](from: map)
        XCTAssertEqual(positions.visiblityCounts.max()!, 41)
        
        positions = [Position](from: _exampleMap)
        XCTAssertEqual(positions.visiblityCounts.max()!, 210)
    }
    
    func test_examples_part2() {
        let positions = [Position](from: _exampleMap)
        let visbility = positions.visiblityCounts
        let visibilityMaximum = visbility.max()!
        XCTAssertEqual(visibilityMaximum, 210)

        let maximumIndex = visbility.firstIndex { $0 == visibilityMaximum }!
        let station = positions[maximumIndex]
        let sortedPositions = positions.sorted(around: station)
        XCTAssertEqual(sortedPositions[199], Position(8, 2))
    }
    
    func test_solution() {
        let positions = [Position](from: try! TestHarnessInput("input10.txt"))
        let visbility = positions.visiblityCounts
        let visibilityMaximum = visbility.max()!
        XCTAssertEqual(visibilityMaximum, 309)

        let maximumIndex = visbility.firstIndex { $0 == visibilityMaximum }!
        let station = positions[maximumIndex]
        let sortedPositions = positions.sorted(around: station)
        XCTAssertEqual(sortedPositions[199], Position(4, 16))
    }
    
}


// MARK: - Private Implementation
private struct InteriorPositions: Sequence, IteratorProtocol {
    
    init(between a: Position, and b: Position) {
        current = a
        step = (b &- a).reduced
        target = b
    }
    
    mutating func next() -> Position? {
        guard current != target else { return nil }
        current = current &+ step
        guard current != target else { return nil }
        return current
    }
    
    private var current: Position
    private let step: Position
    private let target: Position
    
}

extension Array where Element == Position {
    
    var visiblityCounts: [Int] {
        let fastPositions = Set(self)
        return self.map {
            visibility(from: $0, fastPositions: fastPositions)
        }
    }
    
    init<Lines>(from lines: Lines) where Lines: Sequence, Lines.Element == String {
        var result = [Position]()
        
        for (y, row) in lines.enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.append(Position(x, y))
            }
        }

        self = result
    }
    
    init(from map: String) {
        var result = [Position]()

        for (y, row) in map.split(separator: "\n").enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.append(Position(x, y))
            }
        }
        
        self = result
    }
    
    func visibility(
        from station: Position, fastPositions: Set<Position>
    ) -> Int {
        return self.filter { target in
            guard station != target else { return false }
            return InteriorPositions(between: station, and: target)
                .allSatisfy { return !fastPositions.contains($0) }
        }.count
    }
    
    func sorted(around station: Position) -> Self {
        guard count > 1 else { return self }
        
        func delta(_ position: Position) -> Position {
            return position &- station
        }
        
        var result = self
        result.removeAll { delta($0) == .zero }
        
        result.sort {
            let a = delta($0)
            let b = delta($1)
            
            if a.reduced == b.reduced {
                return a.cityBlockLength < b.cityBlockLength
            } else {
                return a.angle < b.angle
            }
        }
        
        for index in 1 ..< result.count {
            // important: Avoid infinite loop if theres a co-linear group at the end.
            for _ in index ..< count {
                guard
                    delta(result[index - 1]).reduced == delta(result[index]).reduced
                else { break }
                
                let blockedPosition = result.remove(at: index)
                result.append(blockedPosition)
            }
        }
        
        return result
    }
    
}


// Private Input
private let _exampleMap = """
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
