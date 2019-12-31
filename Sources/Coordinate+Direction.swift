//
//  Coordinate+Direction.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public extension Coordinate {
    
    /// - Important: Assumes the origin is in the upper-left corner.
    static func +(coordinate: Coordinate, direction: Direction) -> Coordinate {
        switch direction {
        case .north: return Coordinate(coordinate.x, coordinate.y - 1)
        case .south: return Coordinate(coordinate.x, coordinate.y + 1)
        case .west:  return Coordinate(coordinate.x - 1, coordinate.y)
        case .east:  return Coordinate(coordinate.x + 1, coordinate.y)
        }
    }
    
}
