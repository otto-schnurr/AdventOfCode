//
//  Day12.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/20/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day12: XCTestCase {

    func test_examples_part1() {
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
        
    func test_examples_part2() {
        let moons = [
            Moon(position: Vector(-1, 0, 2)),
            Moon(position: Vector(2, -10, -7)),
            Moon(position: Vector(4, -8, 8)),
            Moon(position: Vector(3, 5, -1)),
        ]
        var system = System(moons: moons)
        var history = Set<System<Vector>>()
        while !history.contains(system) {
            history.insert(system)
            system.tic()
        }
        XCTAssertEqual(history.count, 2772)
    }
    
    func test_solutions() {
        var system = System(moons: _moons)
        for _ in 1...1_000 { system.tic() }
        XCTAssertEqual(system.energy, 12351)
    }
    
}


// MARK: - Private
private let _moons = [
    Moon(position: Vector(3, 3, 0)),
    Moon(position: Vector(4, -16, 2)),
    Moon(position: Vector(-10, -6, 5)),
    Moon(position: Vector(-3, 0, -13)),
]

private protocol Quantity: Hashable {
    static var zero: Self  { get }
    static func +(_ lhs: Self, _ rhs: Self) -> Self
    static func -(_ lhs: Self, _ rhs: Self) -> Self
    func signum() -> Self
}

private struct Vector: Quantity {
    
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
    
    func signum() -> Vector {
        return Vector(x.signum(), y.signum(), z.signum())
    }
    
}

private struct Moon<T> where T: Quantity {
    
    typealias Element = T
    
    var position: T
    var velocity = T.zero
    
    mutating func applyGravity(from other: Moon) {
        let gravity = (other.position - self.position).signum()
        velocity = velocity + gravity
    }
    
    mutating func tic() { position = position + velocity }
    
}

extension Moon: Hashable { }

private extension Moon where Element == Vector {
    var energy: Int { position.lenth * velocity.lenth }
}

private struct System<T> where T: Quantity {
    
    typealias Element = T

    init(moons: [Moon<T>]) {
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
    
    private var moons: [Moon<T>]
    
}

extension System: Hashable { }

private extension System where Element == Vector {
    var energy: Int { moons.map { $0.energy }.reduce(0, +) }
}
