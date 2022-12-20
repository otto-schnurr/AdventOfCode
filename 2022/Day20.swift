#!/usr/bin/env swift sh

//  A solution for https://adventofcode.com/2022/day/20
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

import Algorithms // https://github.com/apple/swift-algorithms

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}
var _list = StandardInput().compactMap(Int.init)

func mix(cycleCount: Int, decryptionKey: Int) -> [Int] {
    var list = Array(_list.map { $0 * decryptionKey }.enumerated())
    
    for originalIndex in (0 ..< list.count).cycled(times: cycleCount) {
        let sourceIndex = list.firstIndex { $0.offset == originalIndex }!
        let source = list.remove(at: sourceIndex)
        
        var targetIndex = (sourceIndex + source.element) % list.count
        targetIndex = targetIndex < 0 ? list.count + targetIndex : targetIndex
        
        if targetIndex == 0 {
            list.append(source)
        } else {
            list.insert(source, at: targetIndex)
        }
    }
    
    return list.map { $0.element }
}

func coordinates(for list: [Int]) -> [Int] {
    let zeroIndex = list.firstIndex { $0 == 0 }!
    return [1_000, 2_000, 3_000].map { list[(zeroIndex + $0) % list.count] }
}

let part1 = coordinates(for: mix(cycleCount: 1, decryptionKey: 1))
let part2 = coordinates(for: mix(cycleCount: 10, decryptionKey: 811_589_153))
print("part 1 : \(part1.reduce(0, +))")
print("part 2 : \(part2.reduce(0, +))")
