//
//  Day16.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/16/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day16: XCTestCase {
    
    func test_example() {
        let data = "12345678".data(using: .utf8)!
        let signal = data.map { Int($0) - 48 }
        XCTAssertEqual(
            signal.convolved(phaseCount: 4),
            [0, 1, 0, 2, 9, 4, 9, 8]
        )
    }

}


// MARK: - Private
private let _signal: [Int] = {
    let resourceURL = URL(testHarnessResource: "input16.txt")
    let data = try! Data(contentsOf: resourceURL)
    return data.map { Int($0) - 48 }
}()

private let _basePattern = [0, 1, 0, -1]

private struct Pattern: Sequence, IteratorProtocol {
    
    let order: Int
    var index = 1
    
    init(order: Int) { self.order = order }
    
    mutating func next() -> Int? {
        let patternIndex = (index / order) % _basePattern.count
        index += 1
        return _basePattern[patternIndex]
    }

}

private extension Array where Element == Int {
    
    func convolved(phaseCount: Int) -> Self {
        var result = self
        
        for _ in 1...phaseCount {
            result = (1...result.count).map { result.convolved(order: $0) }
        }
        
        return result
    }
    
    func convolved(order: Int) -> Element {
        let pattern = Pattern(order: order)
        let accumulation = zip(self, pattern).reduce(0) { result, entry in
            return result + entry.0 * entry.1
        }
        return abs(accumulation) % 10
    }
    
}
