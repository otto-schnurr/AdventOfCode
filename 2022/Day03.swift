#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/3
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

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

let priorities = StandardInput()
    .compactMap { $0 }
    .compactMap {
        let middle = $0.count / 2
        return Set($0.prefix(middle)).intersection($0.suffix(middle)).first
    }.compactMap {
        Character(String($0)).priority
    }
print(priorities.reduce(0, +))
