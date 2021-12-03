//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day02.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/2
//  Created by Otto Schnurr on 12/3/2020.
//

import XCTest

final class Day02: XCTestCase {

    func test_example() {
        let commands = [
            "forward 5", "down 5", "forward 8",
            "up 3",      "down 8", "forward 2"
        ].map { Command(text: $0)! }
        let result = commands.reduce(Position.zero) { previousPosition, command in
            command.apply(to: previousPosition)
        }
        XCTAssertEqual(result.x * result.y, 150)
    }

    func test_solution() {
        let commands = TestHarnessInput("input02.txt")!.map { Command(text: $0)! }
        let result = commands.reduce(Position.zero) { previousPosition, command in
            command.apply(to: previousPosition)
        }
        XCTAssertEqual(result.x * result.y, 2117_664)
    }

}


// MARK: - Privates
private typealias Position = SIMD2<Int>

private struct Command {
    
    let direction: String
    let distance: Int
    
    init?(text: String) {
        let components = text
            .split(separator: " ")
            .map { String($0) }
        guard
            components.count == 2,
            let integer = Int(components[1])
        else { return nil }

        direction = components[0]
        distance = integer
    }
    
    func apply(to position: Position) -> Position {
        var result = position

        switch direction {
        case "forward": result.x += distance
        case "down":    result.y += distance
        case "up":      result.y -= distance
        default:        break
        }
        
        return result
    }
    
}
