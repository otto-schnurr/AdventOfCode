#!/usr/bin/env swift sh

import AdventOfCode // ..

let original = readLine()!.split(separator: ",").map { Int($0)! }

func runAmplifier(phase: Int, source: Int) -> Int {
    let computer = Computer(program: original)
    computer.inputBuffer = [phase, source]
    computer.run()
    return computer.outputBuffer[0]
}

func run(phases: [Int]) -> Int {
    return phases.reduce(0) { runAmplifier(phase: $1, source: $0) }
}

print(Array(0..<5).permutations.map(run).reduce(0, max))
