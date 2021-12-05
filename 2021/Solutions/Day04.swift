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
        
        let result = _solve(numbers: numbers, boards: boards) { boards in
            boards.contains { $0.bingo }
        }
        XCTAssertEqual(result, 4_512)
    }
    
    func test_solution() {
        let lines = Array(TestHarnessInput("input04.txt", includeEmptyLines: true)!)
        let (numbers, boards) = _parse(lines)
        
        let result = _solve(numbers: numbers, boards: boards) { boards in
            boards.contains { $0.bingo }
        }
        XCTAssertEqual(result, 54_275)
    }
    
}


// MARK: - Private
private func _parse(_ lines: [String]) -> (numbers: [Int], boards: [Board]) {
    let groups = lines.split(separator: "").map { Array($0) }
    
    let numbers = groups[0][0].split(separator: ",").compactMap { Int(String($0)) }
    
    let boards = groups[1...].map { (group: [String]) -> Board in
        let numbers = group.flatMap {
            line in line.split(separator: " ").compactMap { Int($0) }
        }
        return Board(numbers: numbers)
    }
    
    return (numbers, boards)
}

private func _solve(
    numbers: [Int], boards: [Board], winningCriteria: (_ boards: [Board]) -> Bool
) -> Int {
    var updatedBoards = boards

    for nextNumber in numbers {
        for (boardIndex, var board) in updatedBoards.enumerated() {
            board.mark(number: nextNumber)
            updatedBoards[boardIndex] = board
            
            if winningCriteria(updatedBoards) {
                return nextNumber * board.unmarkedSum
            }
        }
    }
    
    return 0
}

private struct Board {
    
    let numbers: [Int]
    private(set) var marks = IndexSet()
    
    var bingo: Bool {
        return _winningIndexSets.contains { winningSet in
            marks.contains(integersIn: winningSet)
        }
    }
    
    var unmarkedSum: Int {
        let sum = numbers.reduce(0, +)
        let markedSum = marks.map { numbers[$0] }.reduce(0, +)
        return sum - markedSum
    }
    
    mutating func mark(number: Int) {
        if let index = numbers.firstIndex(of: number) {
            marks.insert(index)
        }
    }
    
}

private let _winningIndexSets: [IndexSet] = {
    let winningRows = stride(from: 0, to: 25, by: 5).map {
        IndexSet($0 ..< ($0 + 5))
    }
    let winningColumns = (0 ..< 5).map {
        IndexSet(stride(from: $0, to: $0 + 25, by: 5))
    }
    
    return [ winningRows, winningColumns ].flatMap { $0 }
}()
