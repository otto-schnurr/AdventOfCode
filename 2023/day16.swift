#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2023/day/16
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2023 Otto Schnurr

typealias Position = SIMD2<Int>
typealias Terrain = Character
typealias Map = [Position: Terrain]

// MARK: Types
enum Direction {
    case up, down, left, right
    
    var reversed: Self {
        switch self {
        case .up:    return .down
        case .down:  return .up
        case .left:  return .right
        case .right: return .left
        }
    }
    
    var offset: Position {
        switch self {
        case .up:    return Position(0, -1)
        case .down:  return Position(0, +1)
        case .left:  return Position(-1, 0)
        case .right: return Position(+1, 0)
        }
    }
    
    func traversing(_ terrain: Terrain) -> [Self] {
        switch terrain {
        case "\\":
            switch self {
            case .up:    return [ .left ]
            case .down:  return [ .right ]
            case .left:  return [ .up ]
            case .right: return [ .down ]
            }
            
        case "/":
            return self.reversed.traversing("\\")
            
        case "|":
            switch self {
            case .left, .right: return [ .up, .down ]
            default:            return [ self ]
            }
            
        case "-":
            switch self {
            case .up, .down: return [ .left, .right ]
            default:         return [ self ]
            }
        
        default:
            return [ self ]
        }
    }
}

struct Traversal: Hashable {
    let position: Position
    let direction: Direction

    init(_ position: Position, _ direction: Direction) {
        self.position = position
        self.direction = direction
    }
}

extension Map {
    init(lines: [String]) {
        var result: Map = [:]
        
        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                result[Position(x, y)] = character
            }
        }
        
        self = result
    }
}

// MARK: Data
struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let lines = Array(StandardInput())
let mapSize = (width: lines[0].count, height: lines.count)
let map = Map(lines: lines)

func activation(for map: Map, startingFrom traversal: Traversal) -> Int {
    var history = Set<Traversal>()
    apply(traversal)

    func apply(_ traversal: Traversal) {
        guard
            !history.contains(traversal),
            let terrain = map[traversal.position]
        else { return }
        
        history.insert(traversal)
        
        for newDirection in traversal.direction.traversing(terrain) {
            let newPosition = traversal.position &+ newDirection.offset
            apply(Traversal(newPosition, newDirection))
        }
    }
    
    return Set(history.map { $0.position }).count
}

let activations = [
    (0 ..< mapSize.height).map { y in Traversal(Position(0, y), .right) },
    (0 ..< mapSize.height).map { y in Traversal(Position(mapSize.width - 1, y), .left) },
    (0 ..< mapSize.width).map { x in Traversal(Position(x, 0), .down) },
    (0 ..< mapSize.width).map { x in Traversal(Position(x, mapSize.height - 1), .up) }
]
    .flatMap { $0 }
    .map { activation(for: map, startingFrom: $0) }

print("part 1 : \(activations.first!)")
print("part 2 : \(activations.max()!)")
