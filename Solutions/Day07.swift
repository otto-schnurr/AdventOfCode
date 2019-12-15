//
//  Day07.swift
//  AdventOfCode/Solutions
//  
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

class Day07: XCTestCase {
    
    func test_solution() {
        let system = AmplifierSystem(count: 5, program: _program)

        XCTAssertEqual(
            Array(0..<5).permutations.map(system.configureAndRun).reduce(0, max),
            21000
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
private let _program = [
    3, 8, 1001, 8, 10, 8, 105, 1, 0, 0, 21, 46, 59, 72, 93, 110,
    191, 272, 353, 434, 99999, 3, 9, 101, 4, 9, 9, 1002, 9, 3, 9, 1001,
    9, 5, 9, 102, 2, 9, 9, 1001, 9, 5, 9, 4, 9, 99, 3, 9,
    1002, 9, 5, 9, 1001, 9, 5, 9, 4, 9, 99, 3, 9, 101, 4, 9,
    9, 1002, 9, 4, 9, 4, 9, 99, 3, 9, 102, 3, 9, 9, 101, 3,
    9, 9, 1002, 9, 2, 9, 1001, 9, 5, 9, 4, 9, 99, 3, 9, 1001,
    9, 2, 9, 102, 4, 9, 9, 101, 2, 9, 9, 4, 9, 99, 3, 9,
    1002, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9,
    102, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9,
    102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9,
    101, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9,
    1001, 9, 2, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 99, 3,
    9, 101, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3,
    9, 101, 1, 9, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3,
    9, 1002, 9, 2, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3,
    9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3,
    9, 102, 2, 9, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 99,
    3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9,
    3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9,
    3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9,
    3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9,
    3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9,
    99, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4,
    9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4,
    9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4,
    9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4,
    9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4,
    9, 99, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 1001, 9, 1, 9,
    4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 102, 2, 9, 9,
    4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 101, 1, 9, 9,
    4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9,
    4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9,
    4, 9, 99
]
