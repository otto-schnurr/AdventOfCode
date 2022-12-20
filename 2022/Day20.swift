#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/20
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let list = StandardInput().compactMap(Int.init)

print("list count: \(list.count), unique count: \(Set(list).count)")
