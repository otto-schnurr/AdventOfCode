#!/usr/bin/env swift sh

import AdventOfCode // ..

let original = readLine()!.split(separator: ",").map { Int($0)! }

func makeProgram(noun: Word, verb: Word) -> Program {
    var program = original
    program[1] = noun
    program[2] = verb
    return program
}

func run(noun: Int, verb: Int) -> Int {
    let computer = Computer(program: makeProgram(noun: noun, verb: verb))
    computer.run()
    return computer.firstWord!
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
