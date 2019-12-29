//
//  Day12.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/20/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

// Setting this to true will include tests that take a long time to run.
private let _enableAllTests = false

final class Day12: XCTestCase {

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
        let moonsX = [
            Moon(position: -1), Moon(position: 2),
            Moon(position: 4), Moon(position: 3)
        ]
        let moonsY = [
            Moon(position: 0), Moon(position: -10),
            Moon(position: -8), Moon(position: 5)
        ]
        let moonsZ = [
            Moon(position: 2), Moon(position: -7),
            Moon(position: 8), Moon(position: -1)
        ]

        let epochX = findEpoch(for: moonsX)
        let epochY = findEpoch(for: moonsY)
        let epochZ = findEpoch(for: moonsZ)

        XCTAssertEqual(
            Combinatorics.lcm(Combinatorics.lcm(epochX, epochY), epochZ),
            2772
        )
    }
    
    func test_solutions() {
        var system = System(moons: _moons)
        for _ in 1...1_000 { system.tic() }
        XCTAssertEqual(system.energy, 12351)

        guard _enableAllTests else { return }
        
        let moonsX = [
            Moon(position: _moons[0].position.x),
            Moon(position: _moons[1].position.x),
            Moon(position: _moons[2].position.x),
            Moon(position: _moons[3].position.x),
        ]
        let moonsY = [
            Moon(position: _moons[0].position.y),
            Moon(position: _moons[1].position.y),
            Moon(position: _moons[2].position.y),
            Moon(position: _moons[3].position.y),
        ]
        let moonsZ = [
            Moon(position: _moons[0].position.z),
            Moon(position: _moons[1].position.z),
            Moon(position: _moons[2].position.z),
            Moon(position: _moons[3].position.z),
        ]

        let epochX = findEpoch(for: moonsX)
        let epochY = findEpoch(for: moonsY)
        let epochZ = findEpoch(for: moonsZ)

        XCTAssertEqual(
            Combinatorics.lcm(Combinatorics.lcm(epochX, epochY), epochZ),
            380635029877596
        )
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
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    func signum() -> Self
}

extension Int: Quantity { }

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
    
    static func +(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func -(lhs: Vector, rhs: Vector) -> Vector {
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

private func findEpoch<T>(for moons: [Moon<T>]) -> Int {
    var system = System(moons: moons)
    var history = Set<System<T>>()
    
    while !history.contains(system) {
        history.insert(system)
        system.tic()
    }
    
    return history.count
}
