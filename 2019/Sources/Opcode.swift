//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Opcode.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//

enum Opcode: Int {

    typealias ProgramCounter = Int
    typealias InputHandler = () -> Word
    typealias OutputHandler = (Word) -> OutputMode

    case add = 1
    case multiply = 2
    case input = 3
    case output = 4
    case jump_if_true = 5
    case jump_if_false = 6
    case less_than = 7
    case equals = 8
    case adjust_relative_base = 9

    var parameterCount: Int {
        switch self {
        case .input, .output, .adjust_relative_base:
            return 1

        case .jump_if_true, .jump_if_false:
            return 2

        case .add, .multiply, .less_than, .equals:
            return 3
        }
    }

    /// - returns: `true` if execution should continue.
    func apply(
        parameters: [Word],
        result: inout Word,
        programCounter: inout ProgramCounter,
        relativeBase: inout ProgramCounter,
        inputHandler: InputHandler,
        outputHandler: OutputHandler
    ) -> Bool {
        switch self {
        case .add:
            result = parameters[0] + parameters[1]

        case .multiply:
            result = parameters[0] * parameters[1]

        case .input:
            result = inputHandler()

        case .output:
            switch outputHandler(parameters[0]) {
            case .continue: break
            case .yield:    return false
            }

        case .jump_if_true:
            if parameters[0] != 0 { programCounter = parameters[1] }

        case .jump_if_false:
            if parameters[0] == 0 { programCounter = parameters[1] }

        case .less_than:
            result = parameters[0] < parameters[1] ? 1 : 0

        case .equals:
            result = parameters[0] == parameters[1] ? 1 : 0
        
        case .adjust_relative_base:
            relativeBase += parameters[0]
        }
        
        return true
    }

}
