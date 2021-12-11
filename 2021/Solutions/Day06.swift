//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day06.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/6
//  Created by Otto Schnurr on 12/11/2020.
//

import XCTest

final class Day06: XCTestCase {

    func test_example() {
        var population = [3, 4, 3, 1, 2]
        
        for _ in 1...80 { _simulate(&population) }
        XCTAssertEqual(population.count, 5_934)
    }
    
    func test_solution() {
        let line = Array(TestHarnessInput("input06.txt")!).first!
        var population = line.split(separator: ",").compactMap { Int(String($0)) }

        for _ in 1...80 { _simulate(&population) }
        XCTAssertEqual(population.count, 353_079)
    }
    
}


// MARK: - Private
private func _simulate(_ population: inout [Int]) {
    var spawnCount = 0

    for index in 0 ..< population.count {
        population[index] -= 1
        
        if population[index] < 0 {
            population[index] = 6
            spawnCount += 1
        }
    }
    
    population += Array(repeating: 8, count: spawnCount)
}
