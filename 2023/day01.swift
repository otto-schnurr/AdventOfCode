#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2023/day/1
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2023 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let values = StandardInput()
    .compactMap { $0.filter { $0.isNumber } }
    .map { String([ $0.first!, $0.last! ]) }
    .map { Int($0)! }

print("part 1 : \(values.reduce(0, +))")
