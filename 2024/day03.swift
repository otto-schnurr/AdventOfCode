#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2024/day/3
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

import RegexBuilder

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let instruction = Regex {
    "mul("
    Capture { OneOrMore(.digit) }
    ","
    Capture { OneOrMore(.digit) }
    ")"
}
var result = 0

for line in StandardInput() {
    for match in line.matches(of: instruction) {
        result += Int(match.1)! * Int(match.2)!
    }
}
print("part 1 : \(result)")
