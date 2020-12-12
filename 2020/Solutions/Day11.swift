//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day11.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/11
//  Created by Otto Schnurr on 12/10/2020.
//

import Algorithms
import XCTest

final class Day11: XCTestCase {

    func test_examples() {
        let map = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """
        let lines = map.components(separatedBy: .newlines)
        let seats = Set(from: lines)
        let occupiedSeats = _simulate(seats: seats)
        XCTAssertEqual(occupiedSeats.count, 37)
    }

    func test_solution() {
        let lines = TestHarnessInput("input11.txt")!
        let seats = Set(from: lines)
        let occupiedSeats = _simulate(seats: seats)
        XCTAssertEqual(occupiedSeats.count, 2_324)
    }
    
}


// MARK: - Private
private typealias Position = SIMD2<Int>
private typealias Grid = Set<Position>

private func _simulate(seats: Grid) -> Grid {
    var occupiedSeats = Grid()
    var snapShot = Grid()
    
    repeat {
        snapShot = occupiedSeats
        occupiedSeats.fillVacant(from: seats)
        occupiedSeats.pruneCrowds()
    } while occupiedSeats != snapShot
    
    return occupiedSeats
}

private let _adjacentOffsets = [
    Position(-1, -1), Position(0, -1), Position(+1, -1),
    Position(-1,  0),                  Position(+1,  0),
    Position(-1, +1), Position(0, +1), Position(+1, +1)
]

private extension Position {
    var adjacentPositions: [Position] {
        return _adjacentOffsets.map { self &+ $0 }
    }
}

private extension Set where Element == Position {
    
    init<Lines>(from lines: Lines) where Lines: Sequence, Lines.Element == String {
        var result = Set<Position>()
        
        for (y, row) in lines.enumerated() {
            for (x, _) in row.enumerated().filter({ $0.element == "L" }) {
                result.insert(Position(x, y))
            }
        }

        self = result
    }

    func elements(adjacentTo position: Position) -> [Position] {
        return position.adjacentPositions.filter { self.contains($0) }
    }
    
    mutating func fillVacant(from seats: Set<Position>) {
        let emptySeats = seats.filter { elements(adjacentTo: $0).isEmpty }
        formUnion(emptySeats)
    }
    
    mutating func pruneCrowds() {
        let crowdedSeats = filter { elements(adjacentTo: $0 ).count >= 4 }
        subtract(crowdedSeats)
    }
    
}
