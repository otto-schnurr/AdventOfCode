//
//  Day08.swift
//  AdventOfCode/Solutions
//  
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day08: XCTestCase {
    
    func test_example() {
        let pixels = "123456789012".data(using: .utf8)!
        let layers = pixels.asLayers(size: CGSize(width: 3, height: 2))

        let zero = "0".utf8.first!
        let zeroCounts = layers.map{ $0.count { $0 == zero } }
        XCTAssertEqual(
            zeroCounts.enumerated().min { $0.1 < $1.1 }?.offset, 0
        )
    }
    
}


// MARK: - Private
private typealias Pixel = UInt8
private typealias Pixels = Data

private extension Pixels {

    func asLayers(size: CGSize) -> [Pixels] {
        guard !isEmpty else { return []  }

        let layerPixelCount = Int(size.width) * Int(size.height)
        guard layerPixelCount > 0 else { return [] }

        return stride(
            from: 0, to: count - layerPixelCount + 1, by: layerPixelCount
        ).map { index in self[index ..< index + layerPixelCount] }
    }

    func count(where _predicate: (Pixel) -> Bool) -> Int {
        return filter(_predicate).count
    }
    
}

private let _pixels = "".data(using: .utf8)!
