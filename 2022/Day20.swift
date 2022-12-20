#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/20
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

var list = Array(StandardInput().compactMap(Int.init).enumerated())
print(list)

for originalIndex in 0..<list.count {
    let sourceIndex = list.firstIndex { $0.offset == originalIndex }!
    let source = list.remove(at: sourceIndex)
    
    var targetIndex = (sourceIndex + source.element) % list.count
    targetIndex = targetIndex < 0 ? list.count + targetIndex : targetIndex
    
    if targetIndex == 0 {
        list.append(source)
    } else {
        list.insert(source, at: targetIndex)
    }
    print(list)
}
