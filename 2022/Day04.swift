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

typealias Section = ClosedRange<Int>
typealias SectionPair = (first: Section, second: Section)

extension Section {
    init?(string: String) {
        let numbers = string.split(separator: "-")
        guard
            numbers.count == 2,
            let first = Int(numbers[0]),
            let last = Int(numbers[1])
        else { return nil }
        self = first ... last
    }
    
    func contains(_ section: Section) -> Bool {
        return section.clamped(to: self) == section
    }
}

let pairs = StandardInput()
    .compactMap { $0 }
    .compactMap { (line: String) -> SectionPair? in
        let rangeStrings = line.split(separator: ",").map { String($0) }
        guard
            rangeStrings.count == 2,
            let firstRange = Section(string: rangeStrings[0]),
            let secondRange = Section(string: rangeStrings[1])
        else { return nil }

        return (firstRange, secondRange)
    }

let completeOverlap = pairs
    .map {
        return $0.first.contains($0.second) || $0.second.contains($0.first) ? 1 : 0
    }

let partialOverlap = pairs
    .map { $0.first.overlaps($0.second) ? 1 : 0 }

print("part 1 : \(completeOverlap.reduce(0, +))")
print("part 2 : \(partialOverlap.reduce(0, +))")
