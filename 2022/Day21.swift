#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/21
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

typealias Name = String
typealias Expression = (lhs: String, operation: String, rhs: String)

var valueFor = [Name: Int]()
var expressionFor = [Name: Expression]()

StandardInput().forEach { line in
    let words = line.split(separator: " ").map(String.init)
    let name = String(words[0].prefix(words[0].count - 1))

    if let value = Int(words[1]) {
        valueFor[name] = value
    } else {
        expressionFor[name] = Expression(
            lhs: words[1], operation: words[2], rhs: words[3]
        )
    }
}

print(valueFor)
print(expressionFor)
