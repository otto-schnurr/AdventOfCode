#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2024/day/2
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

typealias Record = [Int]
let safelyIncreasing = +1 ... +3
let safelyDecreasing = -3 ... -1

let records = StandardInput().map { record in
    record.split(separator: " ").map { Int($0)! }
}
print("part 1 : \(records.filter(isSafe).count)")
print("part 2 : \(records.filter(dampen).count)")

func isSafe(_ record: Record)  -> Bool  {
    let deltas = record.adjacentPairs().map { $1 - $0 }
    return
        deltas.allSatisfy { safelyIncreasing.contains($0) } ||
        deltas.allSatisfy { safelyDecreasing.contains($0) }
}

func dampen(record: Record) -> Bool {
    return
        prune(record, with: safelyIncreasing) ||
        prune(record, with: safelyDecreasing)
}

func prune(_ record: Record, with range: ClosedRange<Int>) -> Bool {
    var result = isSafe(record)
    let deltas = record.adjacentPairs().map { $1 - $0 }

    if let index = deltas.firstIndex(where: { !range.contains($0) }) {
        result = result || (index ... index + 1).contains {
            var pruned = record
            pruned.remove(at: $0)
            return isSafe(pruned)
        }
    }

    return result
}
