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
    
    func test_solution_part1() {
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
    
    func test_solution_part2() {
        let computer = Computer(outputMode: .yield)
        computer.load(_asciiProgram)
        
        // Skip over the map that we've already parsed in part 1.
        var prompt: String
        repeat {
            computer.run()
            prompt = computer.harvestOutputLine()
        } while prompt != "Main:"
        print(prompt, terminator: " ")

        func enter(_ input: String) {
            computer.appendInput(string: input + "\n")
            print(input)
            computer.run()
            print(computer.harvestOutputLine(), terminator: " ")
        }
        
        enter("A,B,A,C,B,C,B,A,C,B")
        enter("L,10,L,6,R,10")
        enter("R,6,R,8,R,8,L,6,R,8")
        enter("L,10,R,8,R,8,L,10")
        enter("n")
        
        var dustAmount = 0
        computer.run()
        
        // Skip over diagnostic map
        while let output = computer.harvestOutput().last {
            dustAmount = output
            computer.run()
        }
        
        XCTAssertEqual(dustAmount, 1234055)
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input17.txt")!
private let _asciiProgram: Program = {
    var program = _program
    program[0] = 2
    return program
}()

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
