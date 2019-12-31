//
//  Day17.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day17: XCTestCase {
    
    func test_solutions() {
        let computer = Computer()
        computer.load(_program)
        computer.run()

        let output = computer.harvestOutputString()
        let screen = Screen(pixels: output.split(separator: "\n").map { Array($0) })!
        screen.render()

        XCTAssertEqual(
            screen.intersections(of: "#").reduce(0) { $0 + $1.x * $1.y },
            9876
        )
        
        let startingPosition = screen.firstCoordinate(of: "^")!
        let commands = screen.trace(
            "#", from: startingPosition, startingDirection: .north
        )
        print(commands)
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input17.txt")!

private struct Command {
    
    let turn: Direction.Turn
    let distance: Int
    
    static func +(command: Command, additionalDistance: Int) -> Command {
        return Command(
            turn: command.turn, distance: command.distance + additionalDistance
        )
    }
    
}

extension Command: CustomStringConvertible {
    var description: String {
        let turnDescription: String
        switch turn {
        case .left:  turnDescription = "L"
        case .right: turnDescription = "R"
        }
        return "\(turnDescription)\(distance)"
    }
}

private extension Screen {
    
    func intersections(of pixel: Pixel) -> [Coordinate] {
        guard width >= 5 && height >= 5 else { return [ ] }

        let offsets = [
            Coordinate(-1, 0), Coordinate(1, 0),
            Coordinate(0, 0),
            Coordinate(0, -1), Coordinate(0, 1)
        ]
        var result = [Coordinate]()
        
        for x in 2 ..< width - 2 {
            for y in 2 ..< height - 2 {
                let center = Coordinate(x, y)
                let pixelValues = offsets.map { self[center + $0] }
                if pixelValues.allSatisfy({ $0 == "#" }) { result.append(center) }
            }
        }
        
        return result
    }
    
    func trace(
        _ path: Pixel, from startingPosition: Coordinate, startingDirection: Direction
    ) -> [Command] {
        var position = startingPosition
        var direction = startingDirection
        var result = [Command]()
        
        while let nextTurn = nextTurn(
            along: path, at: position, heading: direction
        ) {
            direction = direction.turned(nextTurn)
            var command = Command(turn: nextTurn, distance: 0)

            while
                validate(coordinate: position + direction) &&
                self[position + direction] == path {
                    
                position = position + direction
                command = command + 1
            }
            
            if command.distance > 0 { result.append(command) }
        }
        
        return result
    }
    
    func nextTurn(
        along path: Pixel, at position: Coordinate, heading direction: Direction
    ) -> Direction.Turn? {
        return Direction.Turn.all.first { turn in
            let newPosition = position + direction.turned(turn)
            return validate(coordinate: newPosition) && self[newPosition] == path
        }
    }
    
}

private extension Direction {
    static func nextDirections(afterStopping direction: Self) -> [Self] {
        switch direction {
        case .north: return [.west, .east]
        case .south: return [.east, .west]
        case .west:  return [.south, .north]
        case .east:  return [.north, .south]
        }
    }
}
