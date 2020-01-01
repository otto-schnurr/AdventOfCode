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
    
    func test_example() {
        let map = """
        ######
        #..###
        #.#..#
        #.O.##
        ######
        """
        let screen = Screen(pixels: map.split(separator: "\n").map { Array($0) })!
        let startingPoint = Coordinate(2, 3)
        XCTAssertEqual(
            screen.minimumDistanceToFill(
                from: startingPoint, across: Observation.path.pixelValue
            ),
            4
        )
    }
    
    func test_solutions() {
        var display = Display(backgroundColor: " ")
        let droid = Droid()
        XCTAssertEqual(
            droid.distanceToTarget(
                directions: Direction.all, distance: 0,
                from: Coordinate(21, 21), history: &display
            ),
            238
        )
        
        let screen = display.export()!
        screen.render()
        
        let startingPoint = screen.firstCoordinate {
            $0 == Observation.oxygen.pixelValue
        }!
        XCTAssertEqual(
            screen.minimumDistanceToFill(
                from: startingPoint, across: Observation.path.pixelValue
            ),
            392
        )
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input15.txt")!

private enum Observation: Word {
    
    case wall = 0
    case path = 1
    case oxygen = 2

    var pixelValue: Screen.Pixel {
        switch self {
        case .wall:   return "#"
        case .path:   return "."
        case .oxygen: return "O"
        }
    }

}

private struct Droid {
    
    init() {
        computer = Computer(outputMode: .yield)
        computer.load(_program)
    }
    
    func move(_ direction: Direction) -> Observation {
        computer.inputBuffer.append(direction.rawValue)
        computer.run()
        return Observation(rawValue: computer.harvestOutput().first!)!
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
        history[position] = Observation.path.pixelValue
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
        let newPosition = position + direction
        guard history[newPosition] == " " else { return nil }
        
        let observation = move(direction)
        history[newPosition] = observation.pixelValue
        
        switch observation {
        case .wall:
            return nil
            
        case .path:
            let result = distanceToTarget(
                directions: Direction.nextDirections(afterMoving: direction),
                distance: distance + 1,
                from: newPosition,
                history: &history
            )
            
            // important: Unwind droid position as we pop the stack.
            let _ = move(-direction)
            return result
            
        case .oxygen:
            // important: Unwind droid position as we pop the stack.
            let _ = move(-direction)
            return distance + 1
        }
    }
    
}

private extension Direction {
    
    static func nextDirections(afterMoving direction: Self) -> [Self] {
        switch direction {
        case .north: return [.west, .north, .east]
        case .south: return [.east, .south, .west]
        case .west:  return [.south, .west, .north]
        case .east:  return [.north, .east, .south]
        }
    }
    
}

private extension Screen {
    
    func minimumDistanceToFill(
        from startingPosition: Coordinate, across path: Pixel
    ) -> Int {
        var queue = [startingPosition]
        var distanceTable = [startingPosition: 0]
        
        while
            let position = queue.popLast(),
            let distance = distanceTable[position] {
            
            let adjacentPositions = Direction.all
                .map { position + $0 }
                .filter { self.validate(coordinate: $0) && self[$0] == path }
                .filter { !distanceTable.keys.contains($0) }
            queue = adjacentPositions + queue
            adjacentPositions.forEach { distanceTable[$0] = distance + 1 }
        }
        
        return distanceTable.max { $0.value < $1.value }?.value ?? 0
    }
    
}
