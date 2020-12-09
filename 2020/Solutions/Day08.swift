//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day08.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/8
//  Created by Otto Schnurr on 12/8/2020.
//

import XCTest

final class Day08: XCTestCase {

    func test_example() {
        let source = """
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
        """
        let lines = source.components(separatedBy: .newlines)

        let program = Program(lines: lines)!
        var accumulator = 0
        var programCounter = 0
        var traversedInstructions = Set<Int>()
        
        while !traversedInstructions.contains(programCounter) {
            traversedInstructions.insert(programCounter)
            
            let nextInstruction = program[programCounter]
            nextInstruction.operation.apply(
                argument: nextInstruction.argument,
                accumulator: &accumulator,
                programCounter: &programCounter
            )
        }
        
        XCTAssertEqual(accumulator, 5)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
private typealias Program = [Instruction]

private extension Array where Element == Instruction {
    init?(lines: [String]) {
        let program = lines.map({ Instruction(for: $0) })
        guard program.allSatisfy({ $0 != nil }) else { return nil }
        self = program.compactMap { $0 }
    }
}

private struct Instruction {
    
    let operation: Operation
    let argument: Int
    
    init?(for line: String) {
        let components = line.components(separatedBy: .whitespaces)
        guard
            let operation = Operation(rawValue: components[0]),
            let argument = Int(components[1])
        else { return nil }
        
        self.operation = operation
        self.argument = argument
    }
    
}

private enum Operation: String {
    
    case acc, jmp, nop

    func apply(
        argument: Int, accumulator: inout Int, programCounter: inout Int
    ) {
        switch self {
        case .acc:
            accumulator += argument
            programCounter += 1
        case .jmp:
            programCounter += argument
        case .nop:
            programCounter += 1
        }
    }
    
}
