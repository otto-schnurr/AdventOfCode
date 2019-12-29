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
        var display = Display(backgroundColor: ".")
        let droid = Droid()
        XCTAssertEqual(
            droid.distanceToTarget(
                directions: Droid.Direction.all, distance: 0,
                from: Coordinate(24, 14), history: &display
            ),
            238
        )
        display.render()
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
    
    func distanceToTarget(
        directions: [Direction],
        distance: Int,
        from position: Coordinate,
        history: inout Display
    ) -> Int? {
        return directions.map {
            self.searchForTarget(
                heading: $0, distance: distance,
                from: position, history: &history
            )
        }.compactMap { $0 }.min()
    }
    
    func searchForTarget(
        heading direction: Direction,
        distance: Int,
        from position: Coordinate,
        history: inout Display
    ) -> Int? {
        let newPosition = position + direction.asOffset
        guard history[newPosition] != " " else {
            history[newPosition] = " "
            return nil
        }
        
        switch move(direction) {
        case .wall:
            history[newPosition] = "#"
            return nil
            
        case .moved:
            history[newPosition] = " "
            let result = distanceToTarget(
                directions: Direction.nextDirections(afterMoving: direction),
                distance: distance + 1,
                from: newPosition,
                history: &history
            )
            
            if result == nil {
                // important: Unwind droid position.
                let _ = move(direction.reversed)
            }
            
            return result
            
        case .movedToOxygen:
            history[newPosition] = "*"
            return distance + 1
        }
    }
    
}

private extension Droid.Direction {
    
    static func nextDirections(afterMoving direction: Self) -> [Self] {
        switch direction {
        case .north: return [.west, .north, .east]
        case .south: return [.east, .south, .west]
        case .west:  return [.south, .west, .north]
        case .east:  return [.north, .east, .south]
        }
    }

    var reversed: Self {
        switch self {
        case .north: return .south
        case .south: return .north
        case .west:  return .east
        case .east:  return .west
        }
    }
    
    var asOffset: Coordinate {
        switch self {
        case .north: return Coordinate(0, -1)
        case .south: return Coordinate(0, 1)
        case .west:  return Coordinate(-1, 0)
        case .east:  return Coordinate(1, 0)
        }
    }
    
}
