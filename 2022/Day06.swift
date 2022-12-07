#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/6
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

let windowSize = 4

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let markerEnds = StandardInput()
    .compactMap { $0 }
    .map {
        Array($0.windows(ofCount: windowSize))
            .firstIndex { Set($0).count == windowSize }! + windowSize
    }

print(markerEnds.reduce(0, +))
