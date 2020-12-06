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

private let _strides = [
    Stride(3, 1), Stride(1, 1),
    Stride(5, 1), Stride(7, 1), Stride(1, 2)
]

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
        let lines = map.components(separatedBy: .newlines)
        let collisionCounts = _strides.map { _traverse(lines, by: $0) }
        XCTAssertEqual(collisionCounts.first!, 7)
        XCTAssertEqual(collisionCounts.reduce(1, *), 336)
    }
    
    func test_solution() {
        let lines = Array(TestHarnessInput("input03.txt")!)
        let collisionCounts = _strides.map { _traverse(lines, by: $0) }
        XCTAssertEqual(collisionCounts.first!, 278)
        XCTAssertEqual(collisionCounts.reduce(1, *), 9_709_761_600)
    }
    
}


// MARK: - Private
private typealias Stride = SIMD2<Int>

// Simplification recommended by Mike Bell.
private func _traverse(_ lines: [String], by stride: Stride) -> Int {
    var column = 0
    var result = 0

    for row in Swift.stride(from: 0, to: lines.count, by: stride.y) {
        let line = lines[row]
        let index = line.index(line.startIndex, offsetBy: column)
        
        if line[index] == "#" { result += 1 }
        
        column += stride.x
        column %= line.count
    }
    
    return result
}
