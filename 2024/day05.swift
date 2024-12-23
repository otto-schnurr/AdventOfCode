#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2024/day/5
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

typealias Rules = [Int: Set<Int>]
typealias Update = [Int]

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine(strippingNewline: false) }
}

let sections = StandardInput()
    .compactMap { $0 }
    .split(separator: "\n")
    .map { Array($0) }
let rules = parseRules(from: sections[0])
let updates = parseUpdates(from: sections[1])

let fixedUpdates = updates.map { update in
    update.sorted { rules[$0, default: [ ]].contains($1) }
}
let result = zip(updates, fixedUpdates)
    .filter { pair in pair.0 == pair.1 }
    .map { pair in pair.0[pair.0.count / 2] }
print("part 1 : \(result.reduce(0, +))")

func parseRules(from section: [String]) -> Rules {
    var rules = Rules()
    section.forEach { line in
        let pages = line.dropLast().split(separator: "|")
        let previous = Int(pages[0])!
        let subsequent = Int(pages[1])!
        rules[previous, default: [ ]].insert(subsequent)
    }
    return rules
}

func parseUpdates(from section: [String]) -> [Update] {
    section.map { line in
        line.dropLast().split(separator: ",").map { Int($0)! }
    }
}
