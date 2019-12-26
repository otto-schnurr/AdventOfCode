//
//  Program.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public typealias Program = [Word]

extension Array where Element == Word {

    mutating func executeInstruction(
        at programCounter: inout Opcode.ProgramCounter,
        relativeBase: inout Opcode.ProgramCounter,
        inputHandler: Opcode.InputHandler,
        outputHandler: Opcode.OutputHandler
    ) -> Bool {
        guard
            let opcode = Opcode(rawValue: self[programCounter] % 100)
        else { return false }

        let modes = ParameterMode.parse(
            count: opcode.parameterCount, from: self[programCounter]
        )
        programCounter += 1
        
        let remainingWords = self[programCounter ..< programCounter + opcode.parameterCount]
        programCounter += opcode.parameterCount
        
        var lastIndex = 0

        let parameters = zip(modes, remainingWords).map { (mode, word) -> Word in
            switch mode {
            case .position:
                lastIndex = word
                expandToAccomodate(index: lastIndex)
                return self[lastIndex]
            case .immediate:
                return word
            case .relative:
                lastIndex = relativeBase + word
                expandToAccomodate(index: lastIndex)
                return self[lastIndex]
            }
        }

        lastIndex = lastIndex < count ? lastIndex : 0

        return opcode.apply(
            parameters: parameters,
            result: &self[lastIndex],
            programCounter: &programCounter,
            relativeBase: &relativeBase,
            inputHandler: inputHandler,
            outputHandler: outputHandler
        )
    }
    
    mutating func expandToAccomodate(index: Word) {
        defer { assert(index < count) }
        if index < count { return }
        self += Self(repeating: 0, count: index + 1 - count)
    }

}
