#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2024/day/1
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let locationIDs = StandardInput().map { pair in
    pair.split(separator: " ").map { Int($0)! }
}

let lhs = locationIDs.map { $0[0] }.sorted()
let rhs = locationIDs.map { $0[1] }.sorted()
let distances = zip(lhs, rhs).map { abs($0.0 - $0.1) }
print("part 1 : \(distances.reduce(0, +))")

var countForLocation = [Int: Int]()

for locationID in rhs {
    countForLocation[locationID, default: 0] += 1
}

let similarities = lhs.map { $0 * countForLocation[$0, default: 0] }
print("part 2 : \(similarities.reduce(0, +))")
