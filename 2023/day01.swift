#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2023/day/1
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2023 Otto Schnurr

import Foundation

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

// reference: https://www.reddit.com/r/adventofcode/comments/1883ibu/2023_day_1_solutions/kbj2stu/
let annotationForWord = [
    "zero"  : "z0o",
    "one"   : "o1e",
    "two"   : "t2o",
    "three" : "t3e",
    "four"  : "f4r",
    "five"  : "f5e",
    "six"   : "s6x",
    "seven" : "s7n",
    "eight" : "e8t",
    "nine"  : "n9e"
]

func annotateDigits(in line: String) -> String {
    var result = line
    
    for (word, annotation) in annotationForWord {
        result = result.replacingOccurrences(of: word, with: annotation)
    }
    
    return result
}

func value(for string: String) -> Int {
    let digits = string.filter { $0.isNumber }
    return Int(String([ digits.first!, digits.last! ]))!
}

let lines = StandardInput().compactMap { $0 }
let values = lines.map { value(for: $0) }
print("part 1 : \(values.reduce(0, +))")

let annotatedLines = lines.map { annotateDigits(in: $0) }
let annotatedValues = annotatedLines.map { value(for: $0) }
print("part 2 : \(annotatedValues.reduce(0, +))")
