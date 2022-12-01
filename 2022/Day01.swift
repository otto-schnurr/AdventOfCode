#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/1
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Algorithms // git@github.com:apple/swift-algorithms.git

typealias Signal = [Int]

var scan = Signal()
while let line = readLine(), let depth = Int(line) { scan.append(depth) }

func accumulate(_ scan: Signal, windowSize: Int) -> Signal {
    return scan
        .windows(ofCount: windowSize)
        .map { $0.reduce(0, +) }
}

func incrementCount(for signal: Signal) -> Int {
    return signal.adjacentPairs().filter { $0 < $1 }.count
}

print(incrementCount(for: accumulate(scan, windowSize: 1)))
print(incrementCount(for: accumulate(scan, windowSize: 3)))
