#!/usr/bin/env swift sh

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
let unzipped = (
    lhs: locationIDs.map { $0[0] }.sorted(),
    rhs: locationIDs.map { $0[1] }.sorted()
)
let distances = zip(unzipped.lhs, unzipped.rhs).map { abs($0.0 - $0.1) }

print("part 1 : \(distances.reduce(0, +))")
