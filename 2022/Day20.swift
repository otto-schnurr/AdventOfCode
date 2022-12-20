#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/20
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

extension RangeReplaceableCollection where Index == Int {
    mutating func moveElement(from sourceIndex: Index, distance: Index) {
        guard !isEmpty else { return }
        
        let source = sourceIndex % count
        let _target = (source + distance) % count
        let target = _target < 0 ? count + _target : _target
        let element = self[source]
        
        if source < target {
            replaceSubrange(source ..< target, with: self[source + 1 ... target])
        } else if target < source {
            replaceSubrange(target + 1 ... source, with: self[target ..< source])
        }

        replaceSubrange(target ... target, with: [element])
    }
}

var list = Array(StandardInput().compactMap(Int.init).enumerated())
print(list)

for originalIndex in 0..<list.count {
    let source = list.firstIndex { $0.offset == originalIndex }!
    list.moveElement(from: source, distance: list[source].element)
    print(list)
}

print(list)
