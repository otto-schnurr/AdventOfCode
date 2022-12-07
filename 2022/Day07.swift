#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/7
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

var part1 = 0

func processLines(_ iterator: StandardInput.Iterator) -> Int {
    var result = 0
    defer { if result <= 100_000 { part1 += result } }

    while let nextLine = iterator.next() {
        let split = nextLine.split(separator: " ")
        
        if let storage = Int(split[0]) {
            result += storage
        } else if nextLine == "$ cd .." {
            return result
        } else if split[1] == "cd" {
            result += processLines(iterator)
        }
    }

    return result
}

let lines = StandardInput()
_ = processLines(StandardInput().makeIterator())
print(part1)
