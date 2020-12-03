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
        let treePositions = [Position](from: map)
        let mapWidth = map.prefix { $0 != Character("\n") }.count
        let collisionCount = treePositions.count(
            from: .zero, by: Position(3, 1), wrappingWidthBy: mapWidth
        )
        XCTAssertEqual(collisionCount, 7)
    }
    
    func test_solution() {
    }
    
}


// MARK: - Private
private typealias Position = SIMD2<Int32>

private extension Position {
    init(_ x: Int, _ y: Int) {
        self.init(Scalar(x), Scalar(y))
    }
}

extension Array where Element == Position {
    
    init(from map: String) {
        var result = [Position]()

        for (y, row) in map.split(separator: "\n").enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "#" }) {
                result.append(Position(x, y))
            }
        }
        
        self = result
    }
    
    func count(from start: Position, by stride: Position, wrappingWidthBy width: Int) -> Int {
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
