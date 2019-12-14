//
//  Computer.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public final class Computer {
    
    public var inputBuffer = Buffer()
    public private(set) var outputBuffer = Buffer()
    public var firstWord: Word? { return program.first }

    public init(program: Program) {
        self.program = program
    }
    
    public func load(program: Program) {
        self.program = program
        reset()
    }
    
    public func run() {
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


// MARK: - Private
private extension Computer {
    func reset() {
        inputBuffer.removeAll()
        outputBuffer.removeAll()
        programCounter = 0
    }
}
