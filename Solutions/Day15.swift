//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day15.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//

import XCTest
import AdventOfCode

final class Day15: XCTestCase {
    
    func test_example() {
        let grid = Grid(lines: """
        ######
        #..###
        #.#..#
        #.O.##
        ######
        """, backgroundValue: "#"
        )
        let startingPoint = Position(2, 3)
        XCTAssertEqual(grid.span(from: startingPoint), 4)
    }
    
    func test_solutions() {
        let history = Droid().explore().filter {
            $0.value != Observation.wall.pixelValue
        }
        let grid = Grid(data: history)
        grid.render(backgroundValue: "#")
        
        let targetPosition = history.first {
            $0.value == Observation.oxygen.pixelValue
        }!.key
        let start = grid.node(atGridPosition: .zero)!
        let target = grid.node(atGridPosition: targetPosition)!
        
        let moveCount = grid.findPath(from: start, to: target).count - 1
        XCTAssertEqual(moveCount, 238)

        XCTAssertEqual(grid.span(from: targetPosition), 392)
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input15.txt")!

private enum Observation: Word {
    
    case wall = 0
    case path = 1
    case oxygen = 2

    var pixelValue: Pixel.Value {
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
    
    func explore() -> Grid.PixelData {
        var history = [Position.zero: Observation.path.pixelValue]
        explore(directions: Direction.all, from: .zero, history: &history)
        return history
    }
    
    func explore(
        directions: [Direction],
        from position: Position,
        history: inout Grid.PixelData
    ) {
        directions.forEach {
            self.search(heading: $0, from: position, history: &history)
        }
    }
    
    func search(
        heading direction: Direction,
        from position: Position,
        history: inout Grid.PixelData
    ) {
        let newPosition = position + direction
        guard history[newPosition] == nil else { return }
        
        let observation = move(direction)
        history[newPosition] = observation.pixelValue
        
        switch observation {
        case .wall:
            return
            
        case .path, .oxygen:
            explore(
                directions: Direction.nextDirections(afterMoving: direction),
                from: newPosition,
                history: &history
            )
            
            // important: Unwind droid position as we pop the stack.
            let _ = move(-direction)
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
