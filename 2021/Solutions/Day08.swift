//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day08.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/8
//  Created by Otto Schnurr on 12/11/2020.
//

import XCTest

final class Day08: XCTestCase {

    func test_example() {
        let data = """
        be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
        """
        let lines = data.components(separatedBy: .newlines)
        let entries = _parse(lines)
        
        let count = entries.map { _uniqueOutputs(for: $0).count }.reduce(0, +)
        XCTAssertEqual(count, 26)
        
        let sum = entries.map { _digitOutput(for: $0) }.reduce(0, +)
        XCTAssertEqual(sum, 61_229)
    }
    
    func test_solution() {
        let lines = Array(TestHarnessInput("input08.txt")!)
        let entries = _parse(lines)

        let count = entries.map { _uniqueOutputs(for: $0).count }.reduce(0, +)
        XCTAssertEqual(count, 310)
        
        let sum = entries.map { _digitOutput(for: $0) }.reduce(0, +)
        XCTAssertEqual(sum, 915_941)
    }
    
}


// MARK: - Private
private typealias Segments = Set<Character>
private typealias Entry = (patterns: [Segments], output: [Segments])

private func _parse(_ lines: [String]) -> [Entry] {
    return lines.compactMap { line in
        let components = line.split(separator: " ").map { String($0) }
        let groups = components
            .split(separator: "|")
            .map { $0.map { Set($0) } }
        guard groups.count == 2 else { return nil }
        return (patterns: groups[0], output: groups[1])
    }
}

private func _uniqueOutputs(for entry: Entry) -> [Segments] {
    let uniqueLengths = [2, 3, 4, 7]
    return entry.output.filter { uniqueLengths.contains($0.count) }
}

private func _digitMap(_ patterns: [Segments]) -> [Segments] {
    var charactersForDigit = Array(repeating: Segments(), count: patterns.count)
    let sorted = patterns.sorted { $0.count < $1.count }
    
    charactersForDigit[1] = sorted[0] // "1" uses two segments.
    charactersForDigit[7] = sorted[1] // "7" uses three segments.
    charactersForDigit[4] = sorted[2] // "4" uses four segments.
    charactersForDigit[8] = sorted[9] // "8" uses all of the segments.

    charactersForDigit[2] = sorted[3...5].first {
        // "2" overlaying "4" activates all segments.
        $0.union(charactersForDigit[4]) == charactersForDigit[8]
    }!
    charactersForDigit[3] = sorted[3...5].first {
        // "3" uses vertical segments from "1".
        $0.isSuperset(of: charactersForDigit[1])
    }!
    charactersForDigit[5] = sorted[3...5].first {
        // "5" is the remaining 5-segment digit.
        $0 != charactersForDigit[3] && $0 != charactersForDigit[2]
    }!
    
    charactersForDigit[6] = sorted[6...8].first {
        // "6" is the only 6-segment digit not using the vertical "1" segments.
        !$0.isSuperset(of: charactersForDigit[1])
    }!
    charactersForDigit[9] = charactersForDigit[4]
        // Overlay "4" over "3" gives you the segments for "9"
        .union(charactersForDigit[3])
    charactersForDigit[0] = sorted[6...8].first {
        // "0" is the remaining 6-segment digit.
        $0 != charactersForDigit[6] && $0 != charactersForDigit[9]
    }!
    
    return charactersForDigit
}

private func _digitOutput(for entry: Entry) -> Int {
    let sortedSegments = _digitMap(entry.patterns)
    let valueString = entry.output
        .map { String(sortedSegments.firstIndex(of: $0)!) }
        .joined(separator: "")
    return Int(valueString)!
}
