//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day08.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest

private let _black        = Pixel("0")!
private let _white        = Pixel("1")!
private let _transparent  = Pixel("2")!

final class Day08: XCTestCase {
    
    func test_example_1() {
        let pixels = Pixels(string: "123456789012")!
        let layers = pixels.asLayers(size: CGSize(width: 3, height: 2))
        let blackCounts = layers.map{ $0.count(value: _black) }
        let layer = layers[blackCounts.enumerated().min { $0.1 < $1.1 }!.offset]

        XCTAssertEqual(
            layer.count(value: _white) * layer.count(value: _transparent), 1
        )
    }
 
    func test_example_2() {
        let size = CGSize(width: 2, height: 2)
        let pixels = Pixels(string: "0222112222120000")!
        let layers = pixels.asLayers(size: size)
        
        let result = layers.reduce(Pixels(transparentWithSize: size)!) {
            return $0.blended(with: $1)
        }
        XCTAssertEqual(result, Pixels(string: "0110")!)
    }

    func test_solution() {
        let size = CGSize(width: 25, height: 6)
        let layers = _pixels.asLayers(size: size)
        let blackCounts = layers.map{ $0.count(value: _black) }
        let layer = layers[blackCounts.enumerated().min { $0.1 < $1.1 }!.offset]

        XCTAssertEqual(
            layer.count(value: _white) * layer.count(value: _transparent), 1905
        )
        
        layers.reduce(Pixels(transparentWithSize: size)!) {
            return $0.blended(with: $1)
        }.print(width: Int(size.width))
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
                case (_transparent, _):
                    result[index] = other[index]
                default:
                    result[index] = self[index]
            }
        }
        return result
    }
    
    func print(width: Int) {
        guard let rawString = String(data: self, encoding: .utf8) else { return }

        let characters = rawString.map { (c: Character) -> Character in
            switch c {
                case "1": return "⬛️"
                default:  return "⬜️"
            }
        }
        
        for offset in stride(from: 0, to: count, by: width) {
            Swift.print(String(characters[offset ..< offset + width]))
        }
    }
    
}

private let _pixels: Pixels = {
    let resourceURL = URL(testHarnessResource: "input08.txt")
    return try! Data(contentsOf: resourceURL)
}()
