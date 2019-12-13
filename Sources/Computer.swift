//
//  Computer.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

final class Computer {
    
    var inputBuffer = Opcode.Buffer()
    private(set) var outputBuffer = Opcode.Buffer()

    init(program: Program) {
        self.program = program
    }
    
    func run() {
        let outputHandler: Opcode.OutputHandler = { [weak self] in
            self?.outputBuffer.append($0)
        }

        while program.executeInstruction(
            at: &programCounter,
            inputBuffer: &inputBuffer,
            outputHandler: outputHandler
        ) { }
    }
    
    // MARK: Private
    private var programCounter = Opcode.ProgramCounter()
    private var program: Program
    
}
