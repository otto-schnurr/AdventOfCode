#!/usr/bin/env swift  sh

//  A solution for https://adventofcode.com/2024/day/2
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

func isSafe(_ deltas: [Int])  -> Bool  {
    deltas.allSatisfy { (-3 ... -1).contains($0) } ||
    deltas.allSatisfy { (+1 ... +3).contains($0) }
}

let deltas = StandardInput().map { record in
    record
        .split(separator: " ").map { Int($0)! }
        .adjacentPairs().map { $1 - $0 }
}
print("part 1 : \(deltas.filter(isSafe).count)")
