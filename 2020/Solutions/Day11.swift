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
        let lines = """
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
        """.components(separatedBy: .newlines)
        let seats = Grid(from: lines)
        let map = _makeAdjacencyMap(for: seats)
        
        let occupiedSeats = _simulate(seats: seats, map: map)
        XCTAssertEqual(occupiedSeats.count, 37)
    }

    func test_solution() {
        let lines = TestHarnessInput("input11.txt")!
        let seats = Grid(from: lines)
        let map = _makeAdjacencyMap(for: seats)
        
        let occupiedSeats = _simulate(seats: seats, map: map)
        XCTAssertEqual(occupiedSeats.count, 2_324)
    }
    
}


// MARK: - Private
private typealias Position = SIMD2<Int>
private typealias Grid = Set<Position>
private typealias Map = [Position: [Position]]

private func _simulate(seats: Grid, map: Map) -> Grid {
    var occupiedSeats = Grid()
    var snapShot = Grid()
    
    repeat {
        snapShot = occupiedSeats
        occupiedSeats.fillVacant(from: seats, map: map)
        occupiedSeats.pruneCrowds(map: map)
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

    mutating func fillVacant(from seats: Set<Position>, map: Map) {
        var emptySeats = [Position]()

        nextSeat: for seat in seats {
            for adjacentPosition in map[seat, default: [ ]] {
                if contains(adjacentPosition) { continue nextSeat }
            }
            
            emptySeats.append(seat)
        }

        formUnion(emptySeats)
    }
    
    mutating func pruneCrowds(map: Map) {
        var crowdedSeats = [Position]()
        
        nextSeat: for seat in self {
            var neighborCount = 0
            
            for adjacentPosition in map[seat, default: [ ]] {
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

private func _makeAdjacencyMap(for seats: Grid) -> Map {
    var result = Map()
    
    for seat in seats {
        result[seat] = _adjacentOffsets
            .map { seat &+ $0 }
            .filter { seats.contains($0) }
    }

    return result
}
