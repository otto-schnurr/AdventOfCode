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
        inputBuffer: inout Buffer,
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
        
        let parameters = zip(modes, remainingWords).map { (mode, word) -> Word in
            switch mode {
            case .position:
                expandToAccomodate(index: word)
                return self[word]
            case .immediate:
                return word
            }
        }

        var outputIndex = self[programCounter - 1]
        outputIndex = outputIndex < count ? outputIndex : 0

        return opcode.apply(
            parameters: parameters,
            result: &self[outputIndex],
            programCounter: &programCounter,
            relativeBase: &relativeBase,
            inputBuffer: &inputBuffer,
            outputHandler: outputHandler
        )
    }
    
    mutating func expandToAccomodate(index: Word) {
        defer { assert(index < count) }
        if index < count { return }
        self += Self(repeating: 0, count: index + 1 - count)
    }

}
