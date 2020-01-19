//
//  Position.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 1/18/2020.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import CoreGraphics.CGGeometry

/// - Note: This choice makes `Position` compatible with `GKGridGraph`.
public typealias Position = SIMD2<Int32>

public extension Position {
    
    /// - Important: Assumes the origin is in the upper-left corner.
    static func +(position: Position, direction: Direction) -> Position {
        switch direction {
        case .north: return Position(position.x, position.y - 1)
        case .south: return Position(position.x, position.y + 1)
        case .west:  return Position(position.x - 1, position.y)
        case .east:  return Position(position.x + 1, position.y)
        }
    }
    
    var length: Scalar { return abs(x) + abs(y) }

    var angle: CGFloat {
        let result = atan2(CGFloat(x), CGFloat(-y))
        return result >= 0 ? result : result + 2 * .pi
    }
    
    var reduced: Position {
        guard self != .zero else { return self }
        let divisor = Combinatorics.gcd(abs(x), abs(y))
        return Position(x/divisor, y/divisor)
    }

    init(_ x: Int, _ y: Int) {
        self.init(Scalar(x), Scalar(y))
    }
    
}
