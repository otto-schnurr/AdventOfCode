//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day14.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/14
//  Created by Otto Schnurr on 12/14/2020.
//

import XCTest

final class Day14: XCTestCase {

    func test_examples() {
        let lines = """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """.components(separatedBy: .newlines)
        let memory = _initializeMemory(from: lines)
        XCTAssertEqual(memory.values.reduce(0, +), 165)
    }

    func test_solution() {
    }
    
}


// MARK: - Private
typealias Memory = [Int: Int]

private func _initializeMemory(from lines: [String]) -> Memory {
    let instructions = lines.compactMap { Instruction(line: $0) }
    var zerosMask = 0
    var onesMask = 0
    var memory = Memory()

    instructions.forEach {
        switch $0 {
        case .mask(let newZeros, let newOnes):
            zerosMask = newZeros
            onesMask = newOnes
        case .mem(let address, let value):
            memory[address] = (value | onesMask) & zerosMask
        }
    }
    
    return memory
}

private enum Instruction {
    
    case mask(zeros: Int, ones: Int)
    case mem(address: Int, value: Int)
    
    init?(line: String) {
        let words = line.components(separatedBy: .whitespaces)
        guard words.count == 3 else { return nil }
        
        if
            words[0] == "mask",
            let zeros = _isolateZeros(from: words[2]),
            let ones = _isolateOnes(from: words[2]) {
            self = .mask(zeros: zeros, ones: ones)
        } else if
            let address = _parseAddress(from: words[0]),
            let value = Int(words[2]) {
            self = .mem(address: address, value: value)
        } else {
            return nil
        }
    }
    
}

private func _parseAddress(from word: String) -> Int? {
    let brackets = CharacterSet(arrayLiteral: "[", "]")
    let components = word.components(separatedBy: brackets)
    guard
        components.count >= 2 && components[0] ==  "mem"
    else { return nil }
    
    return Int(components[1])
}

private func _isolateZeros(from word: String) -> Int? {
    let binaryNumber = word.replacingOccurrences(of: "X", with: "1")
    return Int(binaryNumber, radix: 2)
}

private func _isolateOnes(from word: String) -> Int? {
    let binaryNumber = word.replacingOccurrences(of: "X", with: "0")
    return Int(binaryNumber, radix: 2)
}
