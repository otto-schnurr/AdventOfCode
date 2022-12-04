#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/4
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Foundation

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

extension IndexSet {
    init?(string: String) {
        let numbers = string.split(separator: "-")
        guard
            numbers.count == 2,
            let first = Int(numbers[0]),
            let last = Int(numbers[1])
        else { return nil }
        self.init(integersIn: first ... last)
    }
}

let rangePairs = StandardInput()
    .compactMap { $0 }
    .compactMap { (line: String) -> [IndexSet]? in
        let rangeStrings = line.split(separator: ",").map { String($0) }
        guard
            rangeStrings.count == 2,
            let firstRange = IndexSet(string: rangeStrings[0]),
            let secondRange = IndexSet(string: rangeStrings[1])
        else { return nil }

        return [firstRange, secondRange]
    }
let fullyContained = rangePairs
    .map {
        let first = $0[0]
        let second = $0[1]
        return
            first.contains(integersIn: second) ||
            second.contains(integersIn: first) ? 1 : 0
    }

print(fullyContained.reduce(0, +))
