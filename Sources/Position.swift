//
//  Position.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 1/18/2020.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import simd

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
    
}
