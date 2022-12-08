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
    remainingLines: inout StandardInput.Iterator,
    subdirectorySizes: inout [Int]
) -> Int {
    var subdirectorySize = 0
    defer { subdirectorySizes.append(subdirectorySize) }
    
    while let nextLine = remainingLines.next() {
        let words = nextLine.split(separator: " ")
        
        if let fileSize = Int(words[0]) {
            subdirectorySize += fileSize
        } else if nextLine == "$ cd .." {
            return subdirectorySize
        } else if words[1] == "cd" {
            subdirectorySize += process(
                remainingLines: &remainingLines,
                subdirectorySizes: &subdirectorySizes
            )
        }
    }

    return subdirectorySize
}

var iterator = StandardInput().makeIterator()
var subdirectorySizes = [Int]()

let usedSpace = process(
    remainingLines: &iterator, subdirectorySizes: &subdirectorySizes
)
let neededSpace = usedSpace - 40_000_000

let part1 = subdirectorySizes.filter { $0 <= 100_000 }.reduce(0, +)
let part2 = subdirectorySizes.filter { $0 >= neededSpace }.min()!

print("part 1 : \(part1)")
print("part 2 : \(part2)")
