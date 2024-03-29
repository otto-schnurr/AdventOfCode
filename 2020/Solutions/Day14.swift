//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day14.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/14
//  Created by Otto Schnurr on 12/14/2020.
//

import Algorithms
import XCTest

final class Day14: XCTestCase {

    func test_firstExample() {
        let lines = """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """.components(separatedBy: .newlines)
        let instructions = lines.compactMap { Instruction(line: $0) }

        let memory = _initializeMemory(from: instructions)
        XCTAssertEqual(memory.values.reduce(0, +), 165)
    }
    
    func test_secondExample() {
        let lines = """
        mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1
        """.components(separatedBy: .newlines)
        let instructions = lines.compactMap { Instruction(line: $0) }

        let memory = _initializeMemory_v2(from: instructions)
        XCTAssertEqual(memory.values.reduce(0, +), 208)
    }

    func test_solution() {
        let lines = Array(TestHarnessInput("input14.txt")!)
        let instructions = lines.compactMap { Instruction(line: $0) }
        
        var memory = _initializeMemory(from: instructions)
        XCTAssertEqual(memory.values.reduce(0, +), 9_628_746_976_360)

        memory = _initializeMemory_v2(from: instructions)
        XCTAssertEqual(memory.values.reduce(0, +), 4_574_598_714_592)
    }
    
}


// MARK: - Private
private typealias Memory = [Int: Int]

private func _initializeMemory(from instructions: [Instruction]) -> Memory {
    var zerosMask = 0
    var onesMask = 0
    var memory = Memory()

    instructions.forEach {
        switch $0 {
        case .mask(let mask):
            zerosMask = _isolateZeros(from: mask)!
            onesMask = _isolateOnes(from: mask)!
        case .mem(let address, let value):
            memory[address] = (value | onesMask) & zerosMask
        }
    }
    
    return memory
}

private func _initializeMemory_v2(from instructions: [Instruction]) -> Memory {
    var mask = ""
    var memory = Memory()

    instructions.forEach {
        switch $0 {
        case .mask(let newMask):
            mask = newMask
        case .mem(let address, let value):
            _permute(address: address, with: mask).forEach { address in
                memory[address] = value
            }
        }
    }
    
    return memory
}

private enum Instruction {
    
    case mask(String)
    case mem(address: Int, value: Int)
    
    init?(line: String) {
        let words = line.components(separatedBy: .whitespaces)
        guard words.count == 3 else { return nil }
        
        if words[0] == "mask" {
            self = .mask(words[2])
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

private func _isolateZeros(from mask: String) -> Int? {
    let binaryNumber = mask.replacingOccurrences(of: "X", with: "1")
    return Int(binaryNumber, radix: 2)
}

private func _isolateOnes(from mask: String) -> Int? {
    let binaryNumber = mask.replacingOccurrences(of: "X", with: "0")
    return Int(binaryNumber, radix: 2)
}

private func _isolateXAsZero(from mask: String) -> Int? {
    let binaryNumber = mask
        .replacingOccurrences(of: "0", with: "1")
        .replacingOccurrences(of: "X", with: "0")
    return Int(binaryNumber, radix: 2)
}

private func _xFactors(from mask: String) -> [Int] {
    return mask.reversed().enumerated()
        .filter { $0.element == "X" }
        .map { 1 << $0.offset }
}

private func _permute(address: Int, with mask: String) -> [Int] {
    guard
        let onesMask = _isolateOnes(from: mask),
        let xMask = _isolateXAsZero(from: mask)
    else { return [ ] }
    
    let baseAddress = (address | onesMask) & xMask
    let factors = _xFactors(from: mask)
    let permutations = (0 ... factors.count).map {
        factors.combinations(ofCount: $0).map { combination in
            Array(combination).reduce(baseAddress, +)
        }
    }
    
    return permutations.flatMap { $0 }
}
