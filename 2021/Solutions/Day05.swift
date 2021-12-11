//  MIT License
//  Copyright © 2021 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day05.swift
//  AdventOfCode/2021/Solutions
//
//  A solution for https://adventofcode.com/2021/day/5
//  Created by Otto Schnurr on 12/5/2020.
//

import XCTest

final class Day05: XCTestCase {

    func test_example() {
        let data = """
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
        """
        let vents = data
            .components(separatedBy: .newlines)
            .compactMap { Vent(text: $0) }
        
        let grid = Grid(vents: vents.filter({ !$0.isDiagonal }))
        XCTAssertEqual(grid.filter({ $0.value >= 2 }).count, 5)
    }

}


// MARK: - Private
private typealias Position = SIMD2<Int>
private typealias Grid = [Position: Int]

private extension Grid {
    init(vents: [Vent]) {
        self.init()
        
        vents.forEach { vent in
            var position = vent.begin
            let stop = vent.end &+ vent.direction

            while position != stop {
                self[position, default: 0] += 1
                position &+= vent.direction
            }
        }
    }
}

private struct Vent {
    
    let begin: Position
    let end: Position

    var isDiagonal: Bool {
        direction.x != 0 && direction.y != 0
    }
    
    var direction: Position {
        let vector = end &- begin
        return Position(x: vector.x.signum(), y: vector.y.signum())
    }
    
    init?(text: String) {
        let components = text.split(separator: " ").map { String($0) }
        guard
            components.count == 3,
            let begin = Position(text: components[0]),
            let end = Position(text: components[2])
        else { return nil }

        self.begin = begin
        self.end = end
    }
    
}

private extension Position {
    
    init?(text: String) {
        let components = text.split(separator: ",").map { String($0) }
        guard
            components.count == 2,
            let x = Scalar(components[0]),
            let y = Scalar(components[1])
        else { return nil }

        self.init(x: x, y: y)
    }
    
}
