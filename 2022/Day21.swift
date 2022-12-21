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

var _valueFor = [Name: Int]()
var _expressionFor = [Name: Expression]()

StandardInput().forEach { line in
    let words = line.split(separator: " ").map(String.init)
    let name = Name(words[0].prefix(words[0].count - 1))

    if let value = Int(words[1]) {
        _valueFor[name] = value
    } else {
        _expressionFor[name] = Expression(
            lhs: words[1], operation: words[2], rhs: words[3]
        )
    }
}

func calculate(_ expression: Expression, valueFor: [Name: Int]) -> Int? {
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

func solve() -> Int? {
    var valueFor = _valueFor
    var expressionFor = _expressionFor
    
    while valueFor["root"] == nil {
        for (name, expression) in expressionFor {
            if let value = calculate(expression, valueFor: valueFor) {
                valueFor[name] = value
                expressionFor.removeValue(forKey: name)
            }
        }
    }
    
    return valueFor["root"]
}

print("part 1 : \(solve()!)")

let rootExpression = _expressionFor["root"]!
_expressionFor["root"] = Expression(
    lhs: rootExpression.lhs, operation: "-", rhs: rootExpression.rhs
)

var range = 0 ... 5_000_000_000_000

// binary search
while range.count > 1 {
    let nextInput =
        range.lowerBound + (range.upperBound - range.lowerBound) / 2
    
    _valueFor["humn"] = nextInput
    let nextOutput = solve()!
    
    switch nextOutput {
    case ..<0 : range = range.lowerBound ... nextInput
    case 0    : range = nextInput ... nextInput
    case 1... : range = nextInput ... range.upperBound
    default   : break
    }
}

_valueFor["humn"] = range.lowerBound - 1
let part2 = solve()! == 0 ? range.lowerBound - 1 : range.lowerBound

print("part 2 : \(part2)")
