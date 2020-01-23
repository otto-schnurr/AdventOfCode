//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day13.swift
//  AdventOfCode/Solutions
//
//  A solution for https://adventofcode.com/2019/day/13
//  Created by Otto Schnurr on 12/21/2019.
//

import XCTest
import AdventOfCode

private let _automaticallyRenderGame = false

final class Day13: XCTestCase {
    
    func test_solution() {
        let game = Game()
        game.run(quarters: 1)
        XCTAssertEqual(
            game.pixelData.filter { $0.value == Game.Tile.block.pixelValue }.count,
            207
        )
        game.render()
        
        game.run(quarters: 2)
        XCTAssertEqual(game.score, 10247)
    }
    
}


// MARK: - Private
private let _segmentDisplayPosition = Position(-1, 0)

private final class Game {
    
    enum Tile: Word {
        case empty = 0
        case wall = 1
        case block = 2
        case paddle = 3
        case ball = 4
    }
    
    private(set) public var score = Word()
    private(set) var pixelData = Grid.PixelData()
    
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
            
            let position = Position(output[0], output[1])

            if position == _segmentDisplayPosition {
                score = output[2]
            } else {
                handle(tile: Tile(rawValue: output[2])!, at: position)
            }
        } while shouldKeepRunning
    }
    
    func render() {
        print()
        print("SCORE: \(score)")
        Grid(data: pixelData).render()
    }
    
    // MARK: Private
    private let computer: Computer
    private var ballPosition: Position?
    private var paddlePosition: Position?
    
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
        
        return Word(ballPosition.x - paddlePosition.x).signum()
    }
    
    func handle(tile: Tile, at position: Position) {
        pixelData[position] = tile.pixelValue
        
        switch tile {
        case .ball:   ballPosition = position
        case .paddle: paddlePosition = position
        default:      break
        }
    }
    
}

private extension Game.Tile {
    var pixelValue: Pixel.Value {
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
