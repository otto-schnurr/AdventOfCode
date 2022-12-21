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
    let name = Name(words[0].prefix(words[0].count - 1))

    if let value = Int(words[1]) {
        valueFor[name] = value
    } else {
        expressionFor[name] = Expression(
            lhs: words[1], operation: words[2], rhs: words[3]
        )
    }
}

func calculate(_ expression: Expression) -> Int? {
    guard
        let lhsValue = valueFor[expression.lhs],
        let rhsValue = valueFor[expression.rhs]
    else { return nil }

    switch expression.operation {
    case "+": return lhsValue + rhsValue
    case "-": return lhsValue - rhsValue
    case "*": return lhsValue * rhsValue
    case "/": return lhsValue / rhsValue
    default: return nil
    }
}

while valueFor["root"] == nil {
    for (name, expression) in expressionFor {
        if let value = calculate(expression) {
            valueFor[name] = value
            expressionFor.removeValue(forKey: name)
        }
    }
}

print("part 1 : \(valueFor["root"]!)")
