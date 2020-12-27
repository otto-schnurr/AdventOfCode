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

    func TOO_SLOW_test_solution() {
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

    mutating func fillVacant(from seats: Set<Position>) {
        var emptySeats = [Position]()

        nextSeat: for seat in seats {
            for offset in _adjacentOffsets {
                let adjacentPosition = seat &+ offset
                if contains(adjacentPosition) { continue nextSeat }
            }
            
            emptySeats.append(seat)
        }

        formUnion(emptySeats)
    }
    
    mutating func pruneCrowds() {
        var crowdedSeats = [Position]()
        
        nextSeat: for seat in self {
            var neighborCount = 0
            
            for offset in _adjacentOffsets {
                let adjacentPosition = seat &+ offset
                neighborCount += contains(adjacentPosition) ? 1 : 0

                if neighborCount >= 4 {
                    crowdedSeats.append(seat)
                    continue nextSeat
                }
            }
        }
        
        subtract(crowdedSeats)
    }
    
}
