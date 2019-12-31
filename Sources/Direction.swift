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
    
}
