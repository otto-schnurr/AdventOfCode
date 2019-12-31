//
//  Direction.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public enum Direction: Word {

    public static var all: [Self] = [.north, .east, .south, .west]

    case north = 1
    case south = 2
    case west = 3
    case east = 4

    public enum Turn: Word {
        case left = 0
        case right = 1
    }

}
    
public extension Direction {

    static prefix func - (direction: Direction) -> Direction {
        switch direction {
        case .north: return .south
        case .south: return .north
        case .west:  return .east
        case .east:  return .west
        }
    }
    
    func turned(_ turn: Turn) -> Direction {
        switch turn {
        case .left:
            switch self {
            case .north: return .west
            case .south: return .east
            case .west:  return .south
            case .east:  return .north
            }

        case .right:
            switch self {
            case .north: return .east
            case .south: return .west
            case .west:  return .north
            case .east:  return .south
            }
        }
    }
    
}
