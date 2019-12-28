//
//  TestHarness.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import Foundation

extension URL {
    // reference: https://stackoverflow.com/a/58034307/148076
    init(testHarnessResource: String) {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        self = thisDirectory
            .appendingPathComponent("Resources")
            .appendingPathComponent(testHarnessResource)
    }
}

public struct TestHarnessInput: Sequence, IteratorProtocol {
    
    init(_ resourceName: String) throws {
        let fileURL = URL(testHarnessResource: resourceName)
        let data = try String(contentsOfFile: fileURL.path, encoding: .utf8)
        lines = data.components(separatedBy: .newlines)
        iterator = lines.makeIterator()
    }
    
    public mutating func next() -> String? {
        let result = iterator.next()
        return result?.isEmpty == true ? nil : result
    }
    
    // MARK: Private
    private let lines: [String]
    private var iterator: IndexingIterator<[String]>
    
}
