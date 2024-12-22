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

var part1 = 0
var part2 = 0
var enabled = true

for line in StandardInput() {
    for match in line.matches(of: instruction) {
        switch match.0.prefix(3) {
            case "do(": enabled = true
            case "don": enabled = false
            default:
                let product = Int(match.2!)! * Int(match.3!)!
                part1 += product
                if enabled { part2 += product }
        }
    }
}
print("part 1 : \(part1)")
print("part 2 : \(part2)")
