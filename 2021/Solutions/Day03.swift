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
    let diagnostic = diagnostics.reduce(Diagnostic.zero, &+)
    let majorityThreshold = diagnostics.count / 2
    return diagnostic.replacing(with: 0, where: diagnostic .<= majorityThreshold).asWord!
}

private func _epsilon(from gamma: Word, bitWidth: Int) -> Word {
    let mask = Word((1 << bitWidth) - 1)
    return ~gamma & mask
}
