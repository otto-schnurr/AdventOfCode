#!/usr/bin/env swift

struct Digits: Sequence, IteratorProtocol {
    
    init(_ value: Int) { remainingDigits = value }
    
    mutating func next() -> Int? {
        guard remainingDigits > 0 else { return nil }
        defer { remainingDigits /= 10 }
        return remainingDigits % 10
    }
    
    private var remainingDigits: Int
    
}

struct DigitPairs: Sequence, IteratorProtocol {
    
    init(_ value: Int) { remainingDigits = value }
    
    mutating func next() -> (Int, Int)? {
        guard remainingDigits >= 10 else { return nil }
        let digits = remainingDigits % 100
        remainingDigits /= 10
        return (digits / 10, digits % 10)
    }
    
    private var remainingDigits: Int
    
}

extension Int {

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

let numbers = readLine()!.split(separator: "-").map { Int($0)! }
let passwords = (numbers[0] ... numbers[1]).filter { 
    $0.hasIncreasingDigits && $0.hasAtleastTwoAdjacentDigits 
}

print("part 1: \(passwords.count)")
print("part 2: \(passwords.filter { $0.hasTwoAdjacentDigits }.count)")