//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

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
        XCTAssertEqual(_runFirstLoop(of: program).accumulator, 5)
        XCTAssertEqual(_fixAndRun(program)!, 8)
    }

    func test_solution() {
        let lines = TestHarnessInput("input08.txt")!
        let program = Program(lines: lines)!
        XCTAssertEqual(_runFirstLoop(of: program).accumulator, 1_797)
        XCTAssertEqual(_fixAndRun(program)!, 1_036)
    }
    
}


// MARK: - Private
private func _runFirstLoop(
    of program: Program
) -> (accumulator: Int, didLoop: Bool) {
    var accumulator = 0
    var lineNumber = 0
    var visitedLines = Set<Int>()

    while !visitedLines.contains(lineNumber) && lineNumber < program.count {
        visitedLines.insert(lineNumber)
        
        let nextInstruction = program[lineNumber]
        nextInstruction.operation.apply(
            argument: nextInstruction.argument,
            accumulator: &accumulator,
            lineNumber: &lineNumber
        )
    }
    
    return (accumulator: accumulator, didLoop: visitedLines.contains(lineNumber))
}

private func _fixAndRun(_ program: Program) -> Int? {
    let lineNumbersToToggle = program.enumerated().filter {
        switch $0.element.operation {
        case .jmp, .nop: return true
        default: return false
        }
    }.map { $0.offset }
    
    var modifiedProgram = program
    
    return lineNumbersToToggle.map { (lineNumber: Int) -> Int? in
        modifiedProgram[lineNumber].toggle()
        let result = _runFirstLoop(of: modifiedProgram)
        modifiedProgram[lineNumber].toggle()
        
        return result.didLoop ? nil : result.accumulator
    }.compactMap { $0 }.first
}

private typealias Program = [Instruction]

private extension Array where Element == Instruction {
    init?<S>(lines: S) where S: Sequence, S.Element == String {
        let program = lines.map({ Instruction(for: $0) })
        guard program.allSatisfy({ $0 != nil }) else { return nil }
        self = program.compactMap { $0 }
    }
}

private struct Instruction {
    
    var operation: Operation
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

    mutating func toggle() {
        switch operation {
        case .acc: break
        case .jmp: operation = .nop
        case .nop: operation = .jmp
        }
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
