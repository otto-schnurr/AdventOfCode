//
//  Day15.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day15: XCTestCase {
    
    func test_solutions() {
        let _ = Droid()
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input15.txt")!

private struct Droid {
    
    enum Direction: Word {
        
        static var all = [Self.north, Self.east, Self.south, Self.west]

        case north = 1
        case south = 2
        case west = 3
        case east = 4
        
        static func nextDirections(afterMoving direction: Self) -> [Self] {
            switch direction {
            case .north: return [.west, .north, .east]
            case .south: return [.east, .south, .west]
            case .west:  return [.south, .west, .north]
            case .east:  return [.north, .east, .south]
            }
        }

    }
    
    enum Status: Word {
        case wall = 0
        case moved = 1
        case movedToOxygen = 2
    }
    
    init() {
        computer = Computer(outputMode: .yield)
        computer.load(_program)
    }
    
    func move(_ direction: Direction) -> Status {
        computer.inputBuffer.append(direction.rawValue)
        computer.run()
        return Status(rawValue: computer.harvestOutput().first!)!
    }
    
    // MARK: Private
    private let computer: Computer
    
}

private extension Droid {
    
    func distanceToTarget(directions: [Direction], distance: Int) -> Int {
        return directions
            .map { self.searchForTarget(heading: $0, distance: distance) }
            .min() ?? 0
    }
    
    func searchForTarget(heading direction: Direction, distance: Int) -> Int {
        switch move(direction) {
        case .wall:
            return Int.max
            
        case .moved:
            return distanceToTarget(
                directions: Direction.nextDirections(afterMoving: direction),
                distance: distance + 1
            )
            
        case .movedToOxygen:
            return distance + 1
        }
    }
    
}
