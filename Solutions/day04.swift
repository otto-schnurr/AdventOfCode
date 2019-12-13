#!/usr/bin/env swift

extension Int {

    var isValidPassword: Bool {
        var remainingDigits = self
        var hasAdjacentDigits = false

        while let (firstDigit, secondDigit) = remainingDigits.lastTwoDigits {
            remainingDigits /= 10
            guard firstDigit <= secondDigit else { return false }
            hasAdjacentDigits = hasAdjacentDigits || (firstDigit == secondDigit)
        }

        return hasAdjacentDigits
    }

    var hasIncreasingDigits: Bool {
        var remainingDigits = self

        while let (firstDigit, secondDigit) = remainingDigits.lastTwoDigits {
            remainingDigits /= 10
            guard firstDigit <= secondDigit else { return false }
        }

        return true
    }

    var hasAdjacenDigits: Bool {
        var result = false

        while let (firstDigit, secondDigit) = remainingDigits.lastTwoDigits {
            remainingDigits /= 10
            result = result || firstDigit == secondDigit
        }

        return result
    }

    var lastTwoDigits: (Int, Int)? {
        guard self > 9 else { return nil }
        let digits = self % 100
        return (digits / 10, digits % 10)
    }

}

let numbers = readLine()!.split(separator: "-").map { Int($0)! }
let range = numbers[0] ... numbers[1]

print("part 1: \(range.filter { $0.isValidPassword }.count)")
