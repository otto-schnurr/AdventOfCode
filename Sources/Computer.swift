//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Computer.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//

public final class Computer {
    
    public typealias InputHandler = () -> Word
    
    public var inputBuffer = Buffer()
    public var firstWord: Word? { return program.first }

    /// - parameter outputMode:
    ///   When set to `.continue`, `run()` will return after each output.
    ///   Otherwise, `.run()` will block until the program is completed.
    public init(outputMode: OutputMode = .continue) {
        self.outputMode = outputMode
    }
    
    public func load(_ program: Program) {
        self.program = program
        reset()
    }
    
    public func run(inputHandler: InputHandler? = nil) {
        let _inputHandler = inputHandler ?? { [weak self] in
            guard let self = self else { return 0 }
            return self.inputBuffer.remove(at: 0)
        }
        
        let outputHandler: Opcode.OutputHandler = { [weak self] in
            guard let self = self else { return .yield }
            self.outputBuffer.append($0)
            return self.outputMode
        }

        while program.executeInstruction(
            at: &programCounter,
            relativeBase: &relativeBase,
            inputHandler: _inputHandler,
            outputHandler: outputHandler
        ) { }
    }
    
    /// Returns any output generated since the last harvest.
    public func harvestOutput() -> Buffer {
        defer { outputBuffer.removeAll() }
        return outputBuffer
    }
    
    // MARK: Internal
    internal let outputMode: OutputMode

    // MARK: Private
    private var programCounter = Opcode.ProgramCounter()
    private var relativeBase = Opcode.ProgramCounter()
    private var program = Program()
    private var outputBuffer = Buffer()
    
}


// MARK: - Private
private extension Computer {
    func reset() {
        inputBuffer.removeAll()
        outputBuffer.removeAll()
        programCounter = 0
        relativeBase = 0
    }
}
