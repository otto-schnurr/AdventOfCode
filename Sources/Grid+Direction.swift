//
//  Grid+Direction.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 1/18/2020.
//  Copyright © 2020 Otto Schnurr. All rights reserved.
//

import simd

public extension vector_int2 {
    
    /// - Important: Assumes the origin is in the upper-left corner.
    static func +(position: vector_int2, direction: Direction) -> vector_int2 {
        switch direction {
        case .north: return vector_int2(position.x, position.y - 1)
        case .south: return vector_int2(position.x, position.y + 1)
        case .west:  return vector_int2(position.x - 1, position.y)
        case .east:  return vector_int2(position.x + 1, position.y)
        }
    }
    
}
