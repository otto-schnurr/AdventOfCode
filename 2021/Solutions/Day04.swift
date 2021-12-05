//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day04.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/4
//  Created by Otto Schnurr on 12/4/2020.
//

import XCTest

final class Day04: XCTestCase {
    
    func test_example() {
        let data = """
        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

        22 13 17 11  0
         8  2 23  4 24
        21  9 14 16  7
         6 10  3 18  5
         1 12 20 15 19

         3 15  0  2 22
         9 18 13 17  5
        19  8  7 25 23
        20 11 10 24  4
        14 21 16 12  6

        14 21 17 24  4
        10 16 15  9 19
        18  8 23 26 20
        22 11 13  6  5
         2  0 12  3  7
        """
        let lines = data.components(separatedBy: .newlines)
        let (numbers, boards) = _parse(lines)
        var boardMarkers = Array(repeating: BoardState(), count: boards.count)
        
        print(numbers)
        print(boards)
    }
    
}


// MARK: - Private
private typealias Board = [Int]
private typealias BoardState = IndexSet

private func _parse(_ lines: [String]) -> (numbers: [Int], boards: [Board]) {
    let groups = lines.split(separator: "").map { Array($0) }
    
    let numbers = groups[0][0].split(separator: ",").compactMap { Int(String($0)) }
    
    let boards = groups[1...].map {
        group in group.flatMap {
            line in line.split(separator: " ").compactMap { Int($0) }
        }
    }
    
    return (numbers, boards)
}
