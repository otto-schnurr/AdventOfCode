//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day17.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//

import XCTest
import AdventOfCode
import GameplayKit

final class Day17: XCTestCase {
    
    func test_solution_part1() {
        let computer = Computer()
        computer.load(_program)
        computer.run()

        let grid = Grid(
            lines: computer.harvestOutputString(),
            backgroundValue: "."
        )
        grid.render()
        
        let intersections = grid.pixels!
            .filter { $0.connectedNodes.count == 4 }
            .compactMap { $0.gridPosition }
        XCTAssertEqual(
            intersections.reduce(0) { $0 + $1.x * $1.y }, 9876
        )

        let startingPosition =
            grid.pixels!.filter { $0.value == "^" }.first!.gridPosition
        let commands = grid.trace(from: startingPosition, startingDirection: .north)
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

private extension Grid {

    func trace(from startingPosition: Position, startingDirection: Direction) -> [Command] {
        var position = startingPosition
        var direction = startingDirection
        var result = [Command]()

        while let nextTurn = nextTurn(at: position, heading: direction) {
            direction = direction.turned(nextTurn)
            var command = Command(turn: nextTurn, distance: 0)

            while node(atGridPosition: position + direction) != nil {
                position = position + direction
                command = command + 1
            }

            if command.distance > 0 { result.append(command) }
        }

        return result
    }

    func nextTurn(at position: Position, heading direction: Direction) -> Direction.Turn? {
        // Weird generics compile error when trying to map { } across Direction.Turn.all
        if let _ = node(atGridPosition: position + direction.turned(.left)) { return .left }
        if let _ = node(atGridPosition: position + direction.turned(.right)) { return .right }
        return nil
    }
    
}
