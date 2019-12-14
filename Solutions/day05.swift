#!/usr/bin/env swift sh

import AdventOfCode // ..

let program = readLine()!.split(separator: ",").map { Int($0)! }

let computer = Computer(program: program)
computer.inputBuffer = [1]
computer.run()
print("part 1: \(computer.outputBuffer.last!)")

computer.load(program: program)
computer.inputBuffer = [5]
computer.run()
print("part 2: \(computer.outputBuffer.last!)")
