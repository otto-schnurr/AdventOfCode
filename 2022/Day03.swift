#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/3
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

extension Character {
    var priority: Int? {
        if isLowercase {
            return Int(asciiValue! - Character("a").asciiValue! + 1)
        } else {
            return Int(asciiValue! - Character("A").asciiValue! + 27)
        }
    }
}

let sacks = StandardInput().compactMap { $0 }

let sackPriorities = sacks
    .compactMap {
        let middle = $0.count / 2
        return Set($0.prefix(middle)).intersection($0.suffix(middle)).first
    }.compactMap {
        Character(String($0)).priority
    }

let badgePriorities = sacks
    .chunks(ofCount: 3)
    .compactMap {
        let firstIndex = $0.startIndex
        let secondIndex = $0.startIndex.advanced(by: 1)
        let thirdIndex = $0.startIndex.advanced(by: 2)
        return Set($0[firstIndex])
            .intersection(Set($0[secondIndex]))
            .intersection(Set($0[thirdIndex]))
    }.compactMap {
        Character(String($0)).priority
    }

print("part 1 : \(sackPriorities.reduce(0, +))")
print("part 2 : \(badgePriorities.reduce(0, +))")
