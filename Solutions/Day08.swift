//
//  Day08.swift
//  AdventOfCode/Solutions
//  
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

private let _zero: Pixel = "0".utf8.first!
private let _one: Pixel  = "1".utf8.first!
private let _two: Pixel  = "2".utf8.first!

class Day08: XCTestCase {
    
    func test_example() {
        let pixels = "123456789012".data(using: .utf8)!
        let layers = pixels.asLayers(size: CGSize(width: 3, height: 2))
        let zeroCounts = layers.map{ $0.count(value: _zero) }
        let layer = layers[zeroCounts.enumerated().min { $0.1 < $1.1 }!.offset]

        XCTAssertEqual(
            layer.count(value: _one) * layer.count(value: _two), 1
        )
    }
 
    func test_solution() {
        let layers = _pixels.asLayers(size: CGSize(width: 25, height: 6))
        let zeroCounts = layers.map{ $0.count(value: _zero) }
        let layer = layers[zeroCounts.enumerated().min { $0.1 < $1.1 }!.offset]

        XCTAssertEqual(
            layer.count(value: _one) * layer.count(value: _two), 1905
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

    func count(value: Pixel) -> Int { return filter { $0 == value }.count }
    
}

private let _pixels: Pixels = {
    let resourceURL = URL.make(testHarnessResource: "input08.txt")
    return try! Data(contentsOf: resourceURL)
}()
