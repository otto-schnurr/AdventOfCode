//
//  Day18.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day18: XCTestCase {
    
    func test_examples() {
        let map = Screen(lines: """
        #########
        #b.A.@.a#
        #########
        """)!
        let startingPoint = map.firstCoordinate { $0 == Terrain.start.pixelValue }!
        XCTAssertEqual(startingPoint, Coordinate(5, 1))
    }

    func test_solutions() {
        XCTAssertEqual(_map.width, 81)
        XCTAssertEqual(_map.height, 81)
    }
    
}


// MARK: - Private
private var _map: Screen = {
    let pixels = try! TestHarnessInput("input18.txt").map({ Array($0) })
    return Screen(pixels: pixels)!
}()

private typealias KeyValue = Screen.Pixel
private typealias DoorValue = Screen.Pixel

private enum Terrain {
    
    case start
    case wall
    case path
    case key(KeyValue)
    case door(DoorValue)
    
    init?(pixelValue: Screen.Pixel) {
        switch pixelValue {
        case "@": self = .start
        case "#": self = .wall
        case ".": self = .path
        case "a"..."z": self = .key(pixelValue)
        case "A"..."Z": self = .door(pixelValue)
        default: return nil
        }
    }
    
}

private extension Terrain {
    
    var pixelValue: Screen.Pixel {
        switch self {
        case .start:
            return "@"
        case .wall:
            return "#"
        case .path:
            return "."
        case .key(let pixelValue):
            return pixelValue
        case .door(let pixelValue):
            return pixelValue
        }
    }
    
    var keyValue: KeyValue? {
        switch self {
        case .key(let value): return value
        default:              return nil
        }
    }
    
    var doorValue: DoorValue? {
        switch self {
        case .door(let value): return value
        default:               return nil
        }
    }
    
}
