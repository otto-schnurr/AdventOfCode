//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day16.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/16
//  Created by Otto Schnurr on 12/16/2020.
//

import XCTest

final class Day16: XCTestCase {

    func test_examples() {
        let lines = """
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50

        your ticket:
        7,1,14

        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12
        """.components(separatedBy: .newlines)
        XCTAssertEqual(_invalidValues(in: lines).reduce(0, +), 71)
    }

    func test_solution() {
        let lines = Array(TestHarnessInput("input16.txt", includeEmptyLines: true)!)
        XCTAssertEqual(_invalidValues(in: lines).reduce(0, +), 20_013)
    }
    
}


// MARK: - Private
private typealias Ticket = [Int]

private func _invalidValues(in lines: [String]) -> [Int] {
    let groups = lines.split(separator: "").map { Array($0) }
    guard groups.count >= 3 else { return [ ] }
    
    let fields = groups[0].compactMap { Field(string: $0) }
    let allowedValues = fields.reduce(IndexSet()) { result, field in
        return result.union(field.range)
    }
    let tickets =
        [ Ticket(string: groups[1][1])! ] +
        groups[2].dropFirst().compactMap { Ticket(string: $0) }

    return tickets.map { ticket in
        ticket.filter { !allowedValues.contains($0) }
    }.flatMap { $0 }
}

private struct Field {

    let name: String
    let range: IndexSet

    init?(string: String) {
        let components = string.components(separatedBy: ": ")
        guard components.count == 2 else { return nil }
        
        let words = components[1].components(separatedBy: .whitespaces)
        guard
            words.count == 3,
            let firstSet = IndexSet(string: words[0]),
            let secondSet = IndexSet(string: words[2])
        else { return nil }
            
        name = components[0]
        range = firstSet.union(secondSet)
    }

}

private extension IndexSet {
    init?(string: String) {
        let words = string.components(separatedBy: "-")
        guard
            words.count >= 2,
            let minimum = Int(words[0]),
            let maximum = Int(words[1])
        else { return nil }
        
        self = IndexSet(minimum ... maximum)
    }
}

private extension Array where Element == Int {
    init?(string: String) {
        let values = string
            .components(separatedBy: .punctuationCharacters)
            .map { Int($0) }
        guard values.allSatisfy({ $0 != nil }) else { return nil }
        self = values.compactMap { $0 }
    }
}
