#!/usr/bin/env swift

struct Input: Sequence, IteratorProtocol {
    func next() -> Int? {
        guard let line = readLine() else { return nil }
        return Int(line)
    }
}

func fuel(for mass: Int) -> Int { return mass / 3 - 2 }

func totalFuel(for mass: Int) -> Int {
    let f = fuel(for: mass)
    return f > 0 ? f + totalFuel(for: f) : 0
}

let input = Array(Input())
print("part 1: \(input.map(fuel).reduce(0, +))")
print("part 2: \(input.map(totalFuel).reduce(0, +))")
