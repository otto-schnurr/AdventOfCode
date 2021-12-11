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
        let individuals = [3, 4, 3, 1, 2]
        let originalPopulation = _parse(individuals)
        
        var population = originalPopulation
        for _ in 1...80 { population = _tick(population) }
        XCTAssertEqual(population.values.reduce(0, +), 5_934)
        
        population = originalPopulation
        for _ in 1...256 { population = _tick(population) }
        XCTAssertEqual(population.values.reduce(0, +), 26_984_457_539)
    }
    
    func test_solution() {
        let line = Array(TestHarnessInput("input06.txt")!).first!
        let individuals = line.split(separator: ",").compactMap { Int(String($0)) }
        let originalPopulation = _parse(individuals)
        
        var population = originalPopulation
        for _ in 1...80 { population = _tick(population) }
        XCTAssertEqual(population.values.reduce(0, +), 353_079)
        
        population = originalPopulation
        for _ in 1...256 { population = _tick(population) }
        XCTAssertEqual(population.values.reduce(0, +), 1_605_400_130_036)
    }
    
}


// MARK: - Private
private typealias Population = [Int: Int]

private func _parse(_ array: [Int]) -> Population {
    return array.reduce(Population()) {
        var population = $0
        population[$1, default: 0] += 1
        return population
    }
}

private func _tick(_ population: Population) -> Population {
    var result = Population()
    
    population.forEach { key, value in
        switch key {
        case 0:
            result[6, default: 0] += value
            result[8, default: 0] += value
        default:
            result[key - 1, default: 0] += value
        }
    }
    
    return result
}
