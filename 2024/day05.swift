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
let fixedManuals = manuals.map { fix(manual: $0, using: rules) }

let result = zip(manuals, fixedManuals)
    .filter { pair in pair.0 == pair.1 }
    .map { pair in pair.0[pair.0.count / 2] }
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

func fix(manual: Manual, using invalidPagesFollowing: Rules) -> Manual {
    let badIndices = manual.enumerated().adjacentPairs()
        .filter { pair in
            let invalidPages = invalidPagesFollowing[pair.0.1, default: [ ]]
            return invalidPages.contains(pair.1.1)
        }.map { pair in
            pair.0.0
        }

    var manual = manual
    badIndices.forEach { manual.swapAt($0, $0 + 1) }
    return manual
}
