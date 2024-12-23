#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2024/day/5
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

typealias Rules = [Int: Set<Int>]
typealias Manual = [Int]

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine(strippingNewline: false) }
}
let sections = StandardInput()
    .compactMap { $0 }
    .split(separator: "\n")
    .map { Array($0) }
let rules = parseRules(from: sections[0])
let manuals = parseManuals(from: sections[1])

let result = manuals
    .filter { verify(manual: $0, against: rules) }
    .map { $0[$0.count / 2] }
print("part 1 : \(result.reduce(0, +))")

func parseRules(from section: [String]) -> Rules {
    var result = Rules()
    section.forEach { line in
        let pages = line.dropLast().split(separator: "|")
        let before = Int(pages[0])!
        let after = Int(pages[1])!
        result[after, default: [ ]].insert(before)
    }
    return result
}

func parseManuals(from section: [String]) -> [Manual] {
    return section.map { line in
        line.dropLast().split(separator: ",").map { Int($0)! }
    }
}

func verify(manual: Manual, against invalidPagesFollowing: Rules) -> Bool {
    return manual.adjacentPairs().allSatisfy {
        !invalidPagesFollowing[$0.0, default: [ ]].contains($0.1)
    }
}
