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
        XCTAssertEqual(
            "12345678".asSignal?.convolved(phaseCount: 4),
            [0, 1, 0, 2, 9, 4, 9, 8]
        )
        XCTAssertEqual(
            "80871224585914546619083218645595".asSignal?.convolved(phaseCount: 100).prefix(8),
            [2, 4, 1, 7, 6, 1, 7, 6]
        )
        XCTAssertEqual(
            "19617804207202209144916044189917".asSignal?.convolved(phaseCount: 100).prefix(8),
            [7, 3, 7, 4, 5, 4, 1, 8]
        )
        XCTAssertEqual(
            "69317163492948606335995924319873".asSignal?.convolved(phaseCount: 100).prefix(8),
            [5, 2, 4, 3, 2, 1, 3, 3]
        )
    }

    func test_solution() {
        XCTAssertEqual(
            _signal.convolved(phaseCount: 100).prefix(8),
            [2, 9, 9, 5, 6, 4, 9, 5]
        )
    }
    
}


// MARK: - Private
private typealias Signal = [Int]

private let _signal: Signal = {
    let resourceURL = URL(testHarnessResource: "input16.txt")
    let data = try! Data(contentsOf: resourceURL)
    return data.map { Int($0) - 48 }.filter { $0 >= 0 }
}()

private let _basePattern = [0, 1, 0, -1]

private extension String {
    var asSignal: Signal? {
        return self.data(using: .utf8)?.map { Int($0) - 48 }
    }
}

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
