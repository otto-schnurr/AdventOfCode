//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day10.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/10
//  Created by Otto Schnurr on 12/10/2020.
//

import XCTest

final class Day10: XCTestCase {

    func test_firstExample() {
        let adapters = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
        let differences = _differences(for: adapters)
        let firstAnswer =
            differences.filter { $0 == 1 }.count *
            (differences.filter { $0 == 3 }.count)
        XCTAssertEqual(firstAnswer, 35)
        XCTAssertEqual(_combinationCount(for: adapters), 8)
    }

    func test_secondExample() {
        let adapters = [
            28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19,
            38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3
        ]
        let differences = _differences(for: adapters)
        let firstAnswer =
            differences.filter { $0 == 1 }.count *
            (differences.filter { $0 == 3 }.count)
        XCTAssertEqual(firstAnswer, 220)
        XCTAssertEqual(_combinationCount(for: adapters), 19_208)
    }
    
    func test_solution() {
        let adapters = TestHarnessInput("input10.txt")!.compactMap { Int($0) }
        let differences = _differences(for: adapters)
        let firstAnswer =
            differences.filter { $0 == 1 }.count *
            (differences.filter { $0 == 3 }.count)
        XCTAssertEqual(firstAnswer, 2_592)
        XCTAssertEqual(_combinationCount(for: adapters), 198_428_693_313_536)
    }
    
}


// MARK: - Private
private func _differences(for adapters: [Int]) -> [Int] {
    let sorted = adapters.sorted()
    return zip([ 0 ] + sorted, sorted).map { $0.1 - $0.0 } + [ 3 ]
}

private func _combinationCount(for adapters: [Int]) -> Int {
    // note: The diff of 3 at the end does not change the count.
    let countPerSlice = _slices(for: [ 0 ] + adapters.sorted())
        .map { (slice) -> Int in
            let combinations = _combinations(for: slice)
            let validCombinatons = combinations.filter { _isValid(combination: $0) }
            return validCombinatons.count
        }
    
    return countPerSlice.reduce(1, *)
}

private func _slices(for sortedAdapters: [Int]) -> [[Int]] {
    var result = [[Int]]()
    var slice = [Int]()
    
    for nextValue in sortedAdapters {
        if let previousValue = slice.last {
            if nextValue - previousValue > 2 {
                result.append(slice)
                slice = [ nextValue ]
            } else {
                slice.append(nextValue)
            }
        } else {
            slice.append(nextValue)
        }
    }
    
    if !slice.isEmpty { result.append(slice) }
    
    return result
}

private func _combinations(for slice: [Int]) -> [[Int]] {
    guard
        slice.count > 2,
        let first = slice.first,
        let last = slice.last
    else { return [ slice ] }
    
    let interior = slice[1 ..< slice.count - 1]
    
    let result = (0 ... interior.count).map {
        interior.combinations(ofCount: $0).map { [ first ] + $0 + [ last ] }
    }.flatMap { $0 }
    
    return result
}

private func _isValid(combination: [Int]) -> Bool {
    assert(!combination.isEmpty)
    guard combination.count > 1 else { return true }

    let differences = zip(combination, combination.dropFirst()).map { $0.1 - $0.0 }
    guard let max = differences.max() else { return false }
    return max <= 3
}
