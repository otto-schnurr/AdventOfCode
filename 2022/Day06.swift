#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/6
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}
let signals = StandardInput().compactMap { $0 }
let part1 = signals.map { markerEnd(for: $0, markerLength: 4)}.reduce(0, +)
let part2 = signals.map { markerEnd(for: $0, markerLength: 14)}.reduce(0, +)

print("part 1 : \(part1)")
print("part 2 : \(part2)")


// MARK: - Private
private func markerEnd(for signal: String, markerLength: Int) -> Int {
    return Array(signal.windows(ofCount: markerLength))
        .firstIndex { Set($0).count == markerLength }! + markerLength
}
