//
//  Array+Permute.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/14/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public enum Combinatorics {
    
    // reference: https://github.com/raywenderlich/swift-algorithm-club
    static func gcd<T>(_ m: T, _ n: T) -> T where T: BinaryInteger {
        var a = T()
        var b = max(m, n)
        var r = min(m, n)
        
        while r != T() {
            a = b
            b = r
            r = a % b
        }
        return b
    }
    
}

public extension Array {
    var permutations: [[Element]] {
        guard !isEmpty else { return [ ] }
        
        var result = [[Element]]()
        Combinatorics.permuteWirth(self, count - 1, result: &result)
        return result
    }
}


// MARK: - Private
private extension Combinatorics {

    // reference https://github.com/raywenderlich/swift-algorithm-club/tree/master/Combinatorics
    static func permuteWirth<T>(_ a: [T], _ n: Int, result: inout [[T]]) {
        if n == 0 {
            result.append(a)
        } else {
            var a = a
            permuteWirth(a, n - 1, result: &result)
            for i in 0..<n {
                a.swapAt(i, n)
                permuteWirth(a, n - 1, result: &result)
                a.swapAt(i, n)
            }
        }
    }

}
