//
//  Program.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

typealias Program = [Word]

extension Array where Element == Word {

    mutating func executeInstruction(
        at programCounter: inout Opcode.ProgramCounter,
        inputBuffer: inout Opcode.Buffer,
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
            case .position:  return self[word]
            case .immediate: return word
            }
        }

        var outputIndex = self[programCounter - 1]
        outputIndex = outputIndex < count ? outputIndex : 0

        opcode.apply(
            parameters: parameters,
            result: &self[outputIndex],
            programCounter: &programCounter,
            inputBuffer: &inputBuffer,
            outputHandler: outputHandler
        )

        return true
    }

}
