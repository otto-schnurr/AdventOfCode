//
//  Day13.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/21/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

private let _automaticallyRenderGame = false

final class Day13: XCTestCase {
    
    func test_solution() {
        let game = Game()
        game.run(quarters: 1)
        XCTAssertEqual(
            game.screen.initialPixelCount(for: Game.Tile.block.characterValue),
            207
        )
        game.render()
        
        game.run(quarters: 2)
        XCTAssertEqual(game.score, 10247)
    }
    
}


// MARK: - Private
private let _segmentDisplayCoordinate = Coordinate(-1, 0)

private final class Game {
    
    enum Tile: Word {
        case empty = 0
        case wall = 1
        case block = 2
        case paddle = 3
        case ball = 4
    }
    
    private(set) public var score = Word()
    private(set) var screen = Display(backgroundColor: " ")
    
    init() {
        computer = Computer(outputMode: .yield)
    }
    
    func run(quarters: Int) {
        var program = _program
        program[0] = quarters
        computer.load(program)

        let inputHandler = { [weak self] in return self?.handleInput() ?? 0 }
        
        var shouldKeepRunning = true

        repeat {
            computer.run(inputHandler: inputHandler)
            computer.run(inputHandler: inputHandler)
            computer.run(inputHandler: inputHandler)
            let output = computer.harvestOutput()
            
            guard output.count >= 3 else {
                shouldKeepRunning = false
                continue
            }
            
            let position = Coordinate(output[0], output[1])

            if position == _segmentDisplayCoordinate {
                score = output[2]
            } else {
                handle(tile: Tile(rawValue: output[2])!, at: position)
            }
        } while shouldKeepRunning
    }
    
    func render() {
        print()
        print("SCORE: \(score)")
        screen.render()
    }
    
    // MARK: Private
    private let computer: Computer
    private var ballPosition: Coordinate?
    private var paddlePosition: Coordinate?
    
}

private extension Game {
    
    func handleInput() -> Word {
        defer {
            if _automaticallyRenderGame { render() }
        }
        guard
            let ballPosition = ballPosition,
            let paddlePosition = paddlePosition
        else { return 0 }
        
        return (ballPosition.x - paddlePosition.x).signum()
    }
    
    func handle(tile: Tile, at position: Coordinate) {
        screen[position] = tile.characterValue
        
        switch tile {
        case .ball:   ballPosition = position
        case .paddle: paddlePosition = position
        default:      break
        }
    }
    
}

private extension Game.Tile {
    var characterValue: Character {
        switch self {
        case .empty:  return " "
        case .wall:   return "X"
        case .block:  return "O"
        case .paddle: return "-"
        case .ball:   return "*"
        }
    }
}

private let _program = Program(testHarnessResource: "input13.txt")!
