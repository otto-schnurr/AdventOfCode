//
//  Day16.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/16/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day16: XCTestCase {
    
    func test_pattern() {
        XCTAssertNil(Pattern(order: 0, count: 1))
        
        var pattern = Pattern(order: 1, count: 5)!
        XCTAssertEqual(pattern.next(), PatternElement(range: (0..<1), factor: +1))
        XCTAssertEqual(pattern.next(), PatternElement(range: (2..<3), factor: -1))
        XCTAssertEqual(pattern.next(), PatternElement(range: (4..<5), factor: +1))
        XCTAssertNil(pattern.next())

        pattern = Pattern(order: 2, count: 11)!
        XCTAssertEqual(pattern.next(), PatternElement(range: (1..<3), factor: +1))
        XCTAssertEqual(pattern.next(), PatternElement(range: (5..<7), factor: -1))
        XCTAssertEqual(pattern.next(), PatternElement(range: (9..<11), factor: +1))
        XCTAssertNil(pattern.next())

        pattern = Pattern(order: 3, count: 17)!
        XCTAssertEqual(pattern.next(), PatternElement(range: (2..<5), factor: +1))
        XCTAssertEqual(pattern.next(), PatternElement(range: (8..<11), factor: -1))
        XCTAssertEqual(pattern.next(), PatternElement(range: (14..<17), factor: +1))
        XCTAssertNil(pattern.next())
    }
    
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

private struct PatternElement: Equatable {
    let range: Range<Int>
    let factor: Int
}

private struct Pattern: Sequence, IteratorProtocol {
    
    let order: Int
    let fullRange: Range<Int>
    var index: Int
    var factor = +1
    
    init?(order: Int, count: Int) {
        guard order > 0 && count > 0 else { return nil }
        self.order = order
        fullRange = 0 ..< count
        index = order - 1
    }
    
    mutating func next() -> PatternElement? {
        guard fullRange.contains(index) else { return nil }
        defer {
            index += 2 * order
            factor = -factor
        }

        let range = (index ..< index + order).clamped(to: fullRange)
        return PatternElement(range: range, factor: factor)
    }

}

private extension Array where Element == Int {
    
    func convolved(phaseCount: Int) -> Self {
        let sum = self.reduce(0, +)
        var result = self
        
        for _ in 1...phaseCount {
            result = (1 ... result.count).map {
                result.convolved(order: $0, sum: sum)!
            }
        }
        
        return result
    }
    
    func convolved(order: Int, sum: Int) -> Element? {
        guard let pattern = Pattern(order: order, count: count) else { return nil }

        let accumulation = pattern.reduce(0) { result, entry in
            return result + entry.factor * integrate(across: entry.range, sum: sum)
        }
        return abs(accumulation) % 10
    }
    
    func integrate(across range: Range<Element>, sum: Int) -> Element {
        guard !range.isEmpty else { return 0 }
        
        let startingEpoch = range.startIndex / count
        let endingEpoch = range.endIndex / count
        let startIndex = range.startIndex % count
        let endIndex = range.endIndex % count

        switch (endingEpoch - startingEpoch, endIndex) {
            case (0, _), (1, 0): return self[range].reduce(0, +)
            default:             break
        }
        
        assert(endingEpoch - startingEpoch > 0)
        
        return
            self[startIndex ..< count].reduce(0, +) +
            (endingEpoch - startingEpoch) * sum +
            self[0 ..< endIndex].reduce(0, +)
    }
    
}
