#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/2
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let rounds = StandardInput().compactMap { $0 }

// TODO: Codify this.
let scoreForRound: [String: Int] = [
    "A X": 1 + 3, "A Y": 2 + 6, "A Z": 3 + 0,
    "B X": 1 + 0, "B Y": 2 + 3, "B Z": 3 + 6,
    "C X": 1 + 6, "C Y": 2 + 0, "C Z": 3 + 3
]

let scoreForOutcome: [String: Int] = [
    "A X": 0 + 3, "A Y": 3 + 1, "A Z": 6 + 2,
    "B X": 0 + 1, "B Y": 3 + 2, "B Z": 6 + 3,
    "C X": 0 + 2, "C Y": 3 + 3, "C Z": 6 + 1
]

let part1 = rounds
    .map { scoreForRound[$0] ?? 0 }
    .reduce(0, +)

let part2 = rounds
    .map { scoreForOutcome[$0] ?? 0 }
    .reduce(0, +)

print("part 1 : \(part1)")
print("part 2 : \(part2)")
