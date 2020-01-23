//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day06.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest

final class Day06: XCTestCase {
    
    func test_solution() {
        let data = Input().reduce([Parent: Children]()) {
            var result = $0
            if result[$1.parent] == nil { result[$1.parent] = [ ] }
            result[$1.parent]!.append($1.child)
            return result
        }
        
        XCTAssertEqual(checksum(parent: "COM", from: 0, data: data), 417916)
        
        let santaPath = path(to: "SAN", from: ["COM"], data: data)
        let myPath = path(to: "YOU", from: ["COM"], data: data)

        let commonPathLength = (1 ..< santaPath.count).reversed().first {
            myPath.starts(with: santaPath[0...$0])
        }!
        let distanceFromYOUtoSAN =
            santaPath.count + myPath.count - 2 * commonPathLength - 4
        
        XCTAssertEqual(distanceFromYOUtoSAN, 523)
    }
    
}


// MARK: - Private
private typealias Parent = String
private typealias Children = [String]

private struct Input: Sequence, IteratorProtocol {
    
    mutating func next() -> (parent: String, child: String)? {
        guard let line = lines.next() else { return nil }
        let components = line.split(separator: ")")
        return (String(components[0]), String(components[1]))
    }

    private var lines = try! TestHarnessInput("input06.txt")
    
}

private func checksum(
    parent: Parent, from previousCount: Int, data: [Parent: Children]
) -> Int {
    guard let children = data[parent] else {
        return previousCount
    }

    return previousCount + children.reduce(0) {
        $0 + checksum(parent: $1, from: previousCount + 1, data: data)
    }
}

private func path(
    to target: String, from previousPath: [String], data: [Parent: Children]
) -> [String] {
    let parent = previousPath.last!
    if parent == target {  return previousPath }

    guard let children = data[parent] else { return [] }

    return children
        .map { path(to: target, from: previousPath + [$0], data: data)}
        .first { !$0.isEmpty } ?? []
}
