//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day16.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/16
//  Created by Otto Schnurr on 12/16/2019.
//

import XCTest

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false

final class Day16: XCTestCase {
    
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
    
    func test_examples_part1() {
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
    
    func test_examples_part2() {
        var signal = "03036732577212944063491565474664".asSignal!.repeating(count: 10_000)
        var offset = signal.offsetFromPrefix
        XCTAssertEqual(
            signal.convolved(phaseCount: 100, offset: offset).prefix(8),
            [8, 4, 4, 6, 2, 0, 2, 6]
        )

        signal = "02935109699940807407585447034323".asSignal!.repeating(count: 10_000)
        offset = signal.offsetFromPrefix
        XCTAssertEqual(
            signal.convolved(phaseCount: 100, offset: offset).prefix(8),
            [7, 8, 7, 2, 5, 2, 7, 0]
        )
        
        signal = "03081770884921959731165446850517".asSignal!.repeating(count: 10_000)
        offset = signal.offsetFromPrefix
        XCTAssertEqual(
            signal.convolved(phaseCount: 100, offset: offset).prefix(8),
            [5, 3, 5, 5, 3, 7, 3, 1]
        )
    }

    func test_solution() {
        XCTAssertEqual(
            _signal.convolved(phaseCount: 100).prefix(8),
            [2, 9, 9, 5, 6, 4, 9, 5]
        )
        
        guard _enableAllTests else { return }
        
        let signal = _signal.repeating(count: 10_000)
        let offset = signal.offsetFromPrefix
        XCTAssertEqual(
            signal.convolved(phaseCount: 100, offset: offset).prefix(8),
            [7, 3, 5, 5, 6, 5, 0, 4]
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

// MARK: Full convolution
private extension Array where Element == Int {

    func makeCumulative() -> Self {
        var total = 0
        return [0] + self.map {
            total += $0
            return total
        }
    }
    
    func convolved(phaseCount: Int) -> Self {
        var result = self
        
        for _ in 1...phaseCount {
            let cumulative = result.makeCumulative()
            assert(cumulative.count == count + 1)
            
            result = (1 ... result.count).map {
                result.convolved(order: $0, cumulative: cumulative)!
            }
        }
        
        return result
    }
    
    func convolved(order: Int, cumulative: Self) -> Element? {
        guard let pattern = Pattern(order: order, count: count) else { return nil }

        let total = pattern.reduce(0) { result, entry in
            return result + entry.factor * integrate(
                across: entry.range, cumulative: cumulative
            )
        }
        return abs(total) % 10
    }
    
    func integrate(across range: Range<Element>, cumulative: Self) -> Element {
        return cumulative[range.endIndex] - cumulative[range.startIndex]
    }
    
}

// MARK: Short Cut Convolution
private extension Array where Element == Int {

    var offsetFromPrefix: Int {
        var factor = 1
        return prefix(7).reversed().reduce(0) { result, element in
            defer { factor *= 10 }
            return result + factor * element
        }
    }
    
    func repeating(count _count: Int) -> Self {
        return Array(Array<Self>(repeating: self, count: _count).joined())
    }

    func convolved(phaseCount: Int, offset: Int) -> Self {
        var result = Array(self[offset...].reversed())
        
        for _ in 1...phaseCount {
            var total = 0
            result = result.map { total += $0; return abs(total) % 10 }
        }
        
        return Array(result.reversed())
    }
    
}
