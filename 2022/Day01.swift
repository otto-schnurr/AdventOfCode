#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/1
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let inventory = StandardInput()
    .map { Int($0) }
    .split(separator: nil)
    .map { $0.compactMap { $0 }.reduce(0, +) }
    .sorted(by: >)

print("top one   : \(inventory.first ?? 0)")
print("top three : \(inventory.prefix(3).reduce(0, +))")
