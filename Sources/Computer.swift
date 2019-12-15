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
    
    public func run() {
        let outputHandler: Opcode.OutputHandler = { [weak self] in
            guard let self = self else { return .yield }
            self.outputBuffer.append($0)
            return self.outputMode
        }

        while program.executeInstruction(
            at: &programCounter,
            inputBuffer: &inputBuffer,
            outputHandler: outputHandler
        ) { }
    }
    
    // MARK: Private
    private let outputMode: OutputMode
    private var programCounter = Opcode.ProgramCounter()
    private var program = Program()
    
}


// MARK: - Private
private extension Computer {
    func reset() {
        inputBuffer.removeAll()
        outputBuffer.removeAll()
        programCounter = 0
    }
}
