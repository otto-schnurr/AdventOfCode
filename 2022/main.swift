#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/7
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

var threshold = 0
var part1 = 0
var part2 = 0

func processLines(_ iterator: inout Array<String>.Iterator) -> Int {
    var storage = 0
    defer {
        if storage <= 100_000 { part1 += storage }
        if storage >= threshold && storage < part2 { part2 = storage }
    }

    while let nextLine = iterator.next() {
        let split = nextLine.split(separator: " ")
        
        if let fileStorage = Int(split[0]) {
            storage += fileStorage
        } else if nextLine == "$ cd .." {
            return storage
        } else if split[1] == "cd" {
            storage += processLines(&iterator)
        }
    }

    return storage
}

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

var lines = Array(StandardInput())
var iterator = lines.makeIterator()
let usedSpace = processLines(&iterator)

threshold = usedSpace - 40_000_000
part1 = 0
part2 = Int.max

iterator = lines.makeIterator()
_ = processLines(&iterator)

print("part 1 : \(part1)")
print("part 2 : \(part2)")
