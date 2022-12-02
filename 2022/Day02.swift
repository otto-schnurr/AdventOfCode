#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/2
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

let scoreForRound: [String: Int] = [
    "A X": 1 + 3, "A Y": 2 + 6, "A Z": 3 + 0,
    "B X": 1 + 0, "B Y": 2 + 3, "B Z": 3 + 6,
    "C X": 1 + 6, "C Y": 2 + 0, "C Z": 3 + 3
]

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let score = StandardInput()
    .compactMap { $0 }
    .map { scoreForRound[$0] ?? 0 }
    .reduce(0, +)

print("score : \(score)")
