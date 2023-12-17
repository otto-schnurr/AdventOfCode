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
    
    func applied(to position: Position) -> Position {
        switch self {
        case .up:    return position &+ Position(0, -1)
        case .down:  return position &+ Position(0, +1)
        case .left:  return position &+ Position(-1, 0)
        case .right: return position &+ Position(+1, 0)
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
}

// MARK: Data
struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let map = Map(lines: Array(StandardInput()))
var history = Set<Traversal>()

func apply(_ traversal: Traversal) {
    guard
        !history.contains(traversal),
        let terrain = map[traversal.position]
    else { return }
    
    history.insert(traversal)
    
    for newDirection in traversal.direction.traversing(terrain) {
        let newPosition = newDirection.applied(to: traversal.position)
        apply(Traversal(position: newPosition, direction: newDirection))
    }
}

apply(Traversal(position: .zero, direction: .right))

print("part 1 : \(Set(history.map { $0.position }).count)")
