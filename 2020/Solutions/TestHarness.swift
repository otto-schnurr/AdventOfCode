//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  TestHarness.swift
//  AdventOfCode-UnitTests
//
//  Created by Otto Schnurr on 11/26/2020.
//

import Foundation
import AdventOfCode

extension URL {

    init?(testHarnessResource: String) {
        let resource = testHarnessResource as NSString
	    guard
            let url = Bundle.module.url(
                forResource: resource.deletingPathExtension, 
                withExtension: resource.pathExtension
            )
        else { return nil }

        self = url
    }

}

public struct TestHarnessInput: Sequence, IteratorProtocol {
    
    init?(_ resourceName: String, includeEmptyLines: Bool = false) {
        guard
            let fileURL = URL(testHarnessResource: resourceName),
            let data = try? String(contentsOf: fileURL, encoding: .utf8)
        else { return  nil }

        self.includeEmptyLines = includeEmptyLines
        lines = data.components(separatedBy: .newlines)
        iterator = lines.makeIterator()
    }
    
    public mutating func next() -> String? {
        let result = iterator.next()
        
        if includeEmptyLines {
            return result
        } else {
            return result?.isEmpty == true ? nil : result
        }
    }
    
    // MARK: Private
    private let includeEmptyLines: Bool
    private let lines: [String]
    private var iterator: IndexingIterator<[String]>
    
}

