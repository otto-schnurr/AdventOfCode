//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day07.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/7
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest
import AdventOfCode

final class Day07: XCTestCase {
    
    func test_example() {
        let program = [
            3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26, 27,
            4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5
        ]
        let system = AmplifierSystem(count: 5, program: program)
        
        XCTAssertEqual(
            system.configureAndRun(phases: [9, 8, 7, 6, 5]), 139629729
        )
    }
    
    func test_solution() {
        let system = AmplifierSystem(count: 5, program: _program)

        XCTAssertEqual(
            Array(0..<5).permutations.map(system.configureAndRun).max(),
            21000
        )
        XCTAssertEqual(
            Array(5..<10).permutations.map(system.configureAndRun).max(),
            61379886
        )
    }
    
}


// MARK: - Private Implementation
private struct AmplifierSystem {
    
    let amplifiers: [Computer]
    let program: Program
    
    init(count: Int, program: Program) {
        // TODO: Figure out a better way to do this.
        var _amplifiers = [Computer]()
        (0 ..< count).forEach { _ in
            return _amplifiers.append(Computer(outputMode: .yield))
        }
        
        amplifiers = _amplifiers
        self.program = program
    }
    
    func configureAndRun(phases: [Word]) -> Word {
        for (amplifier, phase) in zip(amplifiers, phases) {
            amplifier.load(program)
            amplifier.inputBuffer = [phase]
        }
        
        var signal = 0
        var continueLooping = true
        
        while continueLooping {
            continueLooping = false

            for amplifier in amplifiers {
                amplifier.inputBuffer.append(signal)
                amplifier.run()
                guard let output = amplifier.harvestOutput().first else {
                    break
                }
                
                signal = output
                continueLooping = amplifier === amplifiers.last
            }
        }
        
        return signal
    }
    
}


// Private Data
private let _program = Program(testHarnessResource: "input07.txt")!
