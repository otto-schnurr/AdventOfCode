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
        XCTAssertEqual(_runFirstLoop(of: Program(lines: lines)!), 5)
    }

}


// MARK: - Private
private func _runFirstLoop(of program: Program) -> Int {
    var accumulator = 0
    var lineNumber = 0
    var executedLines = Set<Int>()

    while !executedLines.contains(lineNumber) {
        executedLines.insert(lineNumber)
        
        let nextInstruction = program[lineNumber]
        nextInstruction.operation.apply(
            argument: nextInstruction.argument,
            accumulator: &accumulator,
            lineNumber: &lineNumber
        )
    }
    
    return accumulator
}

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
        argument: Int, accumulator: inout Int, lineNumber: inout Int
    ) {
        switch self {
        case .acc:
            accumulator += argument
            lineNumber += 1
        case .jmp:
            lineNumber += argument
        case .nop:
            lineNumber += 1
        }
    }
    
}
