//
//  Day08.swift
//  AdventOfCode/Solutions
//  
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

private let _zero = Pixel("0")!
private let _one  = Pixel("1")!
private let _two  = Pixel("2")!

class Day08: XCTestCase {
    
    func test_example_1() {
        let pixels = Pixels(string: "123456789012")!
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

private extension Pixel {
    init?(_ string: String) {
        guard let result = string.utf8.first else { return nil }
        self = result
    }
}

private extension Pixels {

    var asString: String? {
        return String(data: self, encoding: .utf8)
    }
    
    init?(string: String) {
        guard let result = string.data(using: .utf8) else { return nil }
        self = result
    }
    
    init?(transparentWithSize size: CGSize) {
        let pixelCount = Int(size.width) * Int(size.height)
        guard
            pixelCount > 0,
            let result = Pixels(string: String(repeating: "2", count: pixelCount))
        else { return nil }
        
        self = result
    }
    
    func asLayers(size: CGSize) -> [Pixels] {
        guard !isEmpty else { return []  }

        let layerPixelCount = Int(size.width) * Int(size.height)
        guard layerPixelCount > 0 else { return [] }

        return stride(
            from: 0, to: count - layerPixelCount + 1, by: layerPixelCount
        ).map { index in self.subdata(in: index ..< index + layerPixelCount) }
    }

    func count(value: Pixel) -> Int { return filter { $0 == value }.count }
    
    func blended(with other: Pixels) -> Pixels {
        assert(count == other.count)
        var result = Pixels(count: count)
        for index in 0 ..< count {
            switch (self[index], other[index]) {
                case (_two, _): result[index] = other[index]
                default:        result[index] = self[index]
            }
        }
        return result
    }
    
}

private let _pixels: Pixels = {
    let resourceURL = URL(testHarnessResource: "input08.txt")
    return try! Data(contentsOf: resourceURL)
}()
