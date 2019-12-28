//
//  TestHarness.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import Foundation
import AdventOfCode

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
        let data = try String(contentsOf: fileURL, encoding: .utf8)
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

extension Array where Element == Word {

    init?(testHarnessResource: String) {
        guard
            let lines = try? TestHarnessInput(testHarnessResource)
        else { return nil }
        
        let program = lines.map { Element($0) }
        guard
            !program.contains(where: { $0 == nil })
        else { return nil }
        
        self = program.compactMap { $0 }
    }

}
