#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/7
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

func process(
    remainingLines: inout Array<String>.Iterator,
    hook: (_ subdirectorySize: Int) -> Void
) -> Int {
    var subdirectorySize = 0
    defer { hook(subdirectorySize) }
    
    while let nextLine = remainingLines.next() {
        let word = nextLine.split(separator: " ")
        
        if let fileSize = Int(word[0]) {
            subdirectorySize += fileSize
        } else if nextLine == "$ cd .." {
            return subdirectorySize
        } else if word[1] == "cd" {
            subdirectorySize += process(
                remainingLines: &remainingLines, hook: hook
            )
        }
    }

    return subdirectorySize
}

let lines = Array(StandardInput())
var iterator = lines.makeIterator()
var part1 = 0

let usedSpace = process(remainingLines: &iterator) {
    if $0 <= 100_000 { part1 += $0 }
}

iterator = lines.makeIterator()
let desiredSize = usedSpace - 40_000_000
var part2 = Int.max

_ = process(remainingLines: &iterator) {
    if $0 >= desiredSize && $0 < part2 { part2 = $0 }
}

print("part 1 : \(part1)")
print("part 2 : \(part2)")
