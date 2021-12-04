//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day03.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/3
//  Created by Otto Schnurr on 12/3/2020.
//

import XCTest

final class Day03: XCTestCase {

    func test_example() {
        let diagnostics = [
            "00100", "11110", "10110", "10111", "10101", "01111",
            "00111", "11100", "10000", "11001", "00010", "01010"
        ].map { (text: String) -> Diagnostic in
            return Diagnostic(word: Word(text, radix: 2)!)!
        }

        let gamma = _gamma(from: diagnostics)
        let epsilon = _epsilon(from: gamma, bitWidth: 5)
        XCTAssertEqual(gamma * epsilon, 198)
        
        let oxygen = _gasRating(from: diagnostics, bitWidth: 5) { sum, threshold in
            sum >= threshold ? 1 : 0
        }!
        let co2 = _gasRating(from: diagnostics, bitWidth: 5) { sum, threshold in
            sum >= threshold ? 0 : 1
        }!
        XCTAssertEqual(oxygen * co2, 230)
    }

    func test_solution() {
        let diagnostics = TestHarnessInput("input03.txt")!.map {
            return Diagnostic(word: Word($0, radix: 2)!)!
        }

        let gamma = _gamma(from: diagnostics)
        let epsilon = _epsilon(from: gamma, bitWidth: 12)
        XCTAssertEqual(Int(gamma) * Int(epsilon), 3_985_686)
        
        let oxygen = _gasRating(from: diagnostics, bitWidth: 12) { sum, threshold in
            sum >= threshold ? 1 : 0
        }!
        let co2 = _gasRating(from: diagnostics, bitWidth: 12) { sum, threshold in
            sum >= threshold ? 0 : 1
        }!
        XCTAssertEqual(Int(oxygen) * Int(co2), 2_555_739)
    }
    
}


// MARK: - Private
private typealias Diagnostic = SIMD16<Int>
private typealias Word = Int16

private extension Diagnostic {
    
    var asWord: Word? {
        assert(scalarCount == Word.bitWidth)
        let bits = indices.map { self[$0] != 0 ? "1" : "0" }.joined()
        return Word(bits, radix: 2)
    }
    
    init?(word: Word) {
        let bits =
            repeatElement(0, count: word.leadingZeroBitCount) +
            String(word, radix: 2).compactMap { Int(String($0)) }
        guard bits.count == word.bitWidth else { return nil }
        self.init(bits)
    }
    
}

private func _gamma(from diagnostics: [Diagnostic]) -> Word {
    let sum = diagnostics.reduce(Diagnostic.zero, &+)
    let majorityThreshold = diagnostics.count / 2
    return sum.replacing(with: 0, where: sum .<= majorityThreshold).asWord!
}

private func _epsilon(from gamma: Word, bitWidth: Int) -> Word {
    let mask = Word((1 << bitWidth) - 1)
    return ~gamma & mask
}

private func _gasRating(
    from diagnostics: [Diagnostic],
    bitWidth: Int,
    bitCriteria: (_ sum: Int, _ threshold: Int) -> Int
) -> Word? {
    let firstBitIndex = Diagnostic.scalarCount - bitWidth
    var remainingDiagnostics = diagnostics
    
    for bitIndex in firstBitIndex ..< Diagnostic.scalarCount {
        let sum = remainingDiagnostics.reduce(Diagnostic.zero, &+)
        let threshold = (remainingDiagnostics.count + 1) / 2
        let targetBitValue = bitCriteria(sum[bitIndex], threshold)

        remainingDiagnostics = remainingDiagnostics.filter {
            $0[bitIndex] == targetBitValue
        }
        
        if remainingDiagnostics.count == 1 { return remainingDiagnostics[0].asWord }
    }
    
    return nil
}
