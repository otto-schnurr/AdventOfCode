#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2024/day/3
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2024 Otto Schnurr

import Foundation

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let operand = "mul"
var result = 0

for line in StandardInput() {
    let scanner = Scanner(string: line)

    while !scanner.isAtEnd {
        let _ = scanner.scanUpToString(operand)
        if let product = scanProduct(from: scanner) { result += product }
    }
}
print("part 1 : \(result)")

func scanProduct(from scanner: Scanner) -> Int? {
    guard
        let _ = scanner.scanString(operand),
        let _ = scanner.scanString("("),
        let lhs = scanner.scanInt(),
        let _ = scanner.scanString(","),
        let rhs = scanner.scanInt(),
        let _ = scanner.scanString(")")
    else { return nil }

    return lhs * rhs
}