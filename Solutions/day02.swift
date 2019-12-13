#!/usr/bin/env swift

enum Opcode: Int {
    case add = 1
    case multiply = 2

    func apply(_ first: Int, _ second: Int) -> Int? {
        switch self {
        case .add:      return first + second
        case .multiply: return first * second
        }
    }
}

extension Array where Element == Int {
    mutating func run() {
        var index = 0

        while let result = run(at: index) {
            self[self[index + 3]] = result
            index += 4
        }
    }

    func run(at index: Int) -> Int? {
        return Opcode(rawValue: self[index])?.apply(
            self[self[index + 1]], self[self[index + 2]]
        )
    }
}

let original = readLine()!.split(separator: ",").map { Int($0)! }

func run(noun: Int, verb: Int) -> Int {
    var program = original
    program[1] = noun
    program[2] = verb
    program.run()
    return program[0]
}

print("part 1: \(run(noun: 12, verb: 2))")

for noun in 0..<100 {
    for verb in 0..<100 {
        if run(noun: noun, verb: verb) == 19690720 {
            print("part 2: \(100 * noun + verb)")
            break
        }
    }
}