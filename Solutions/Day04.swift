//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day04.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest

final class Day04: XCTestCase {
    
    func test_solution() {
        let passwords = _passwordRange.filter {
            $0.hasIncreasingDigits && $0.hasAtleastTwoAdjacentDigits
        }

        XCTAssertEqual(passwords.count, 1660)
        XCTAssertEqual(passwords.filter { $0.hasTwoAdjacentDigits }.count, 1135)
    }
    
}


// MARK: - Private
private let _passwordRange = (172851 ... 675869)

private struct Digits: Sequence, IteratorProtocol {
    
    init(_ value: Int) { remainingDigits = value }
    
    mutating func next() -> Int? {
        guard remainingDigits > 0 else { return nil }
        defer { remainingDigits /= 10 }
        return remainingDigits % 10
    }
    
    private var remainingDigits: Int
    
}

private struct DigitPairs: Sequence, IteratorProtocol {
    
    init(_ value: Int) { remainingDigits = value }
    
    mutating func next() -> (Int, Int)? {
        guard remainingDigits >= 10 else { return nil }
        let digits = remainingDigits % 100
        remainingDigits /= 10
        return (digits / 10, digits % 10)
    }
    
    private var remainingDigits: Int
    
}

private extension Int {

    var hasIncreasingDigits: Bool {
        DigitPairs(self).allSatisfy { $0 <= $1 }
    }

    var hasAtleastTwoAdjacentDigits: Bool {
        DigitPairs(self).contains { $0 == $1 }
    }
    
    var hasTwoAdjacentDigits: Bool {
        var previousDigit: Int?
        var adjacentCount = 1
        
        for nextDigit in Digits(self) {
            defer { previousDigit = nextDigit }
            guard nextDigit == previousDigit else {
                if adjacentCount == 2 { return true }
                adjacentCount = 1
                continue
            }
            
            adjacentCount += 1
        }
        
        return adjacentCount == 2
    }

}
