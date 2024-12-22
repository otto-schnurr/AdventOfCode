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

let mul = Regex {
    "mul("
    Capture { OneOrMore(.digit) }
    ","
    Capture { OneOrMore(.digit) }
    ")"
}
let instruction = Regex {
    Capture {
        ChoiceOf {
            "do()"
            "don't()"
            mul
        }
    }
}
var result = 0

for line in StandardInput() {
    for match in line.matches(of: instruction) {
        if match.0.hasPrefix("mul") {
            result += Int(match.2!)! * Int(match.3!)!
        }
    }
}
print("part 1 : \(result)")
