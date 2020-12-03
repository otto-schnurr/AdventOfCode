//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day03.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/3
//  Created by Otto Schnurr on 12/3/2020.
//

import XCTest

final class Day03: XCTestCase {

    func test_example() {
        let map = """
        ..##.......
        #...#...#..
        .#....#..#.
        ..#.#...#.#
        .#...##..#.
        ..#.##.....
        .#.#.#....#
        .#........#
        #.##...#...
        #...##....#
        .#..#...#.#
        """
        let treePositions = Set<Position>(from: map)
        let mapWidth = 11
        
        let strides = [
            Position(3, 1), Position(1, 1),
            Position(5, 1), Position(7, 1), Position(1, 2)
        ]
        let collisionCounts = strides.map {
            treePositions.count(from: .zero, by: $0, widthWrappedTo: mapWidth)
        }
        
        XCTAssertEqual(collisionCounts.first!, 7)
        XCTAssertEqual(collisionCounts.reduce(1, *), 336)
    }
    
    func test_solution() {
        let map = Array(TestHarnessInput("input03.txt")!)
        let treePositions = Set<Position>(from: map)
        let mapWidth = map.first!.count

        let strides = [
            Position(3, 1), Position(1, 1),
            Position(5, 1), Position(7, 1), Position(1, 2)
        ]
        let collisionCounts = strides.map {
            treePositions.count(from: .zero, by: $0, widthWrappedTo: mapWidth)
        }
        
        XCTAssertEqual(collisionCounts.first!, 278)
        XCTAssertEqual(collisionCounts.reduce(1, *), 9_709_761_600)
    }
    
}


// MARK: - Private
private typealias Position = SIMD2<Int32>

private extension Position {
    init(_ x: Int, _ y: Int) {
        self.init(Scalar(x), Scalar(y))
    }
}

extension Set where Element == Position {
    
    init<Lines>(from lines: Lines) where Lines: Sequence, Lines.Element == String {
        var result = Set<Position>()
        
        for (y, row) in lines.enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.insert(Position(x, y))
            }
        }

        self = result
    }

    init(from map: String) {
        var result = Set<Position>()

        for (y, row) in map.split(separator: "\n").enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.insert(Position(x, y))
            }
        }
        
        self = result
    }
    
    func count(from start: Position, by stride: Position, widthWrappedTo width: Int) -> Int {
        var position = start
        var result = 0
        
        while position.y < count {
            let wrappedPosition = Position(Int(position.x) % width, Int(position.y))
            if self.contains(wrappedPosition) { result += 1 }
            position &+= stride
        }
        
        return result
    }
    
}
