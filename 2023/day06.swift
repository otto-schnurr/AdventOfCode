#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2023/day/1
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2023 Otto Schnurr

let times = readLine()!.split(separator: " ").compactMap { Double($0) }
let distances = readLine()!.split(separator: " ").compactMap { Double($0) }

func winningCount(time: Double, distance: Double) -> Int {
    let remainder = ((time * time) - 4.0 * distance).squareRoot()
    let start = 0.5 * (time - remainder)
    let end =  0.5 * (time + remainder)

    return Int(end.rounded(.up) - start.rounded(.down) - 1.0)
}

let winningCounts = zip(times, distances).map(winningCount)
print("part 1: \(winningCounts.reduce(1, *))")
