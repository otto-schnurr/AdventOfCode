//
//  Day12.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/20/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day12: XCTestCase {

    func test_example() {
        
    }
    
}


// MARK: - Private
private struct Vector {
    
    let x: Int
    let y: Int
    let z: Int
    
    var lenth: Int { return abs(x) + abs(y) + abs(z) }
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    static func +(_ lhs: Vector, _ rhs: Vector) -> Vector {
        return Vector(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func -(_ lhs: Vector, _ rhs: Vector) -> Vector {
        return Vector(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
}

private struct Moon {
    
    var position: Vector
    var velocity: Vector
    var energy: Int { position.lenth * velocity.lenth }
    
    mutating func applyGravity(from other: inout Moon) {
        let gravity = Vector(
            (other.position.x - position.x).signum(),
            (other.position.y - position.y).signum(),
            (other.position.z - position.z).signum()
        )
        
        velocity = velocity + gravity
        other.velocity = other.velocity - gravity
    }
    
    mutating func tic() { position = position + velocity }
    
}
