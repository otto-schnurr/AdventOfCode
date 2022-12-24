#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2022/day/22
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2022 Otto Schnurr

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

typealias Position = SIMD2<Int>

enum Direction: Int {
    static let count = 4
    case north, south, west, east
    
    func adjacentPositions(from position: Position) -> Set<Position> {
        let result: [(x: Int, y: Int)]

        switch self {
        case .north:
            result = (position.x - 1 ... position.x + 1)
                .map { ($0, position.y - 1) }
        case .south:
            result = (position.x - 1 ... position.x + 1)
                .map { ($0, position.y + 1) }
        case .west:
            result = (position.y - 1 ... position.y + 1)
                .map { (position.x - 1, $0) }
        case .east:
            result = (position.y - 1 ... position.y + 1)
                .map { (position.x + 1, $0) }
        }
        
        return Set(result.map { Position($0.x, $0.y) })
    }
    
    func applied(to position: Position) -> Position {
        switch self {
        case .north: return Position(position.x, position.y - 1)
        case .south: return Position(position.x, position.y + 1)
        case .west: return Position(position.x - 1, position.y )
        case .east: return Position(position.x + 1, position.y )
        }
    }
}

func iterate(
    directions: [Direction],
    appliedTo positions: Set<Position>,
    handler: (_ position: Position, _ selectedDirection: Direction?) -> Void
) {
    positions.forEach { position in
        var result: Direction?
        defer { handler(position, result) }
        
        let directionActivity = directions.map { direction in
            return !direction
                .adjacentPositions(from: position)
                .intersection(positions)
                .isEmpty
        }
        guard
            // Can't move unless there is something adjacent.
            !directionActivity.allSatisfy({ !$0 }),
            // First direction that has nothing adjacent.
            let selectedIndex = directionActivity.firstIndex(where: { !$0 })
        else { return }
        
        result = directions[selectedIndex]
    }
}

struct Grid {
    private(set) var positions: Set<Position>
    
    init(lines: [String]) {
        let positions = lines.enumerated()
            .map { yPosition, line in
                line.enumerated().filter { xPosition, character in
                    character == "#"
                }.map { xPosition, _ in
                    Position(xPosition, yPosition)
                }
            }.joined()
        
        self.positions = Set(positions)
    }
    
    mutating func apply(_ directions: [Direction]) {
        print("applying: \(directions)")
        print()
        var countFor = [Position: Int]()
        
        iterate(directions: directions, appliedTo: positions) { position, selectedDirection in
            
            if let newPosition = selectedDirection?.applied(to: position) {
                countFor[newPosition, default: 0] += 1
            }
        }

        var nextPositions = Set<Position>()
        
        iterate(directions: directions, appliedTo: positions) { position, selectedDirection in
            var nextPosition = position

            if let selectedDirection {
                let newPosition = selectedDirection.applied(to: position)
                
                if countFor[newPosition, default: 0] == 1 {
                    nextPosition = newPosition
                }
            }
            
            nextPositions.insert(nextPosition)
        }
        
        positions = nextPositions
    }
}

var grid = Grid(lines: Array(StandardInput()))
print()
print(grid)

for roundIndex in 0 ..< 10 {
    let directions = (0 ..< Direction.count).map {
        Direction(rawValue: (roundIndex + $0) % Direction.count)!
    }
    grid.apply(directions)
    
    print("Round \(roundIndex + 1)")
    print(grid)
}

func print(_ grid: Grid) {
    for y in 0 ..< 12 {
        for x in 0 ..< 14 {
            let character = grid.positions.contains(Position(x, y)) ? "#" : "."
            print(character, separator: "", terminator: "")
        }
        print()
    }
    
    print()
}
