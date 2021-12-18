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
        let count = entries
            .map { _uniqueOutputs(for: $0).count }
            .reduce(0, +)
        XCTAssertEqual(count, 26)
    }
    
}


// MARK: - Private
private typealias Entry = (patterns: [String], output: [String])

private func _parse(_ lines: [String]) -> [Entry] {
    return lines.compactMap { line in
        let components = line.split(separator: " ").map { String($0) }
        let groups = components.split(separator: "|").map { $0.map { String($0) } }
        guard groups.count == 2 else { return nil }
        return (patterns: groups[0], output: groups[1])
    }
}

private func _uniqueOutputs(for entry: Entry) -> [String] {
    let uniqueLengths = [2, 3, 4, 7]
    return entry.output.filter { uniqueLengths.contains($0.count) }
}
