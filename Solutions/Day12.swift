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
        var moons = [
            Moon(position: Vector(-1, 0, 2)),
            Moon(position: Vector(2, -10, -7)),
            Moon(position: Vector(4, -8, 8)),
            Moon(position: Vector(3, 5, -1)),
        ]
        var system = System(moons: moons)
        for _ in 1...10 { system.tic() }
        XCTAssertEqual(system.energy, 179)
        
        moons = [
            Moon(position: Vector(-8, -10, 0)),
            Moon(position: Vector(5, 5, 10)),
            Moon(position: Vector(2, -7, 3)),
            Moon(position: Vector(9, -8, -3))
        ]
        system = System(moons: moons)
        for _ in 1...100 { system.tic() }
        XCTAssertEqual(system.energy, 1940)
    }
    
}


// MARK: - Private
private struct Vector {
    
    static let zero = Vector(0, 0, 0)
    
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

extension Vector: CustomStringConvertible {
    var description: String { "(\(x), \(y), \(z))" }
}

private struct Moon {
    
    var position: Vector
    var velocity = Vector.zero
    var energy: Int { position.lenth * velocity.lenth }
    
    mutating func applyGravity(from other: Moon) {
        let gravity = Vector(
            (other.position.x - position.x).signum(),
            (other.position.y - position.y).signum(),
            (other.position.z - position.z).signum()
        )
        velocity = velocity + gravity
    }
    
    mutating func tic() { position = position + velocity }
    
}

extension Moon: CustomStringConvertible {
    var description: String {
        "position: \(position), velocity: \(velocity)"
    }
}

private struct System {
    
    var energy: Int { moons.map { $0.energy }.reduce(0, +) }
    
    init(moons: [Moon]) {
        self.moons = moons
    }
    
    mutating func tic() {
        for first in 0 ..< moons.count {
            for second in first + 1 ..< moons.count {
                moons[first].applyGravity(from: moons[second])
                moons[second].applyGravity(from: moons[first])
            }
        }
        
        for index in 0 ..< moons.count { moons[index].tic() }
    }
    
    private var moons: [Moon]
    
}

extension System: CustomStringConvertible {
    var description: String {
        moons.map { $0.description }.joined(separator: "\n")
    }
}
