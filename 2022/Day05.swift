#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/5
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

typealias Label = Character
typealias Instruction = (amount: Int, source: Int, destination: Int)

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine(strippingNewline: false) }
}
let sections = StandardInput()
    .compactMap { $0 }
    .split(separator: "\n")
    .map { Array($0) }

var stacks = parseStacks(from: sections[0])
parseInstructions(from: sections[1]).forEach {
    let cargo = stacks[$0.source].suffix($0.amount)
    stacks[$0.source] = stacks[$0.source].dropLast($0.amount)
    stacks[$0.destination].append(contentsOf: cargo.reversed())
}

print(stacks.map { $0.last! })


// MARK: - Private
private func parseStacks(from section: [String]) -> [[Label]] {
    let crates = section.map {
        let start = $0.index($0.startIndex, offsetBy: 1)
        return Array($0.suffix(from: start).striding(by: 4))
    }

    let stackCount = crates[0].count

    var stacks: [[Label]] = Array(repeating: [Label](), count: stackCount)
    crates.reversed().forEach {
        for (index, label) in $0.enumerated() {
            stacks[index].append(label)
        }
    }
    
    return stacks.map { $0.filter { $0.isLetter } }
}

private func parseInstructions(from section: [String]) -> [Instruction] {
    return section.map {
        let tokens = $0.dropLast().split(separator: " ")
        return (Int(tokens[1])!, Int(tokens[3])! - 1, Int(tokens[5])! - 1)
    }
}
