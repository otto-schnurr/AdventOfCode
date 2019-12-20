//
//  Coordinate.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/20/19.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import CoreGraphics.CGGeometry

public struct Coordinate: Equatable, Hashable {

    public static let zero = Coordinate(0, 0)

    public let x: Int
    public let y: Int
    
    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

}

public extension Coordinate {
    
    var length: Int { return abs(x) + abs(y) }
    
    var angle: CGFloat {
        let result = atan2(CGFloat(x), CGFloat(-y))
        return result >= 0 ? result : result + 2 * .pi
    }
    
    var reduced: Coordinate {
        guard self != .zero else { return self }
        let divisor = gcd(abs(x), abs(y))
        return Coordinate(x/divisor, y/divisor)
    }

    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    static func *(_ factor: Int, coordinate: Coordinate) -> Coordinate {
        return Coordinate(factor * coordinate.x, factor * coordinate.y)
    }
    
    static func *(coordinate: Coordinate, _ factor: Int) -> Coordinate {
        return factor * coordinate
    }
    
}

extension Coordinate: CustomStringConvertible {
    public var description: String { return "(\(x), \(y))" }
}


// MARK: - Private

// reference: https://github.com/raywenderlich/swift-algorithm-club
private func gcd(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}
