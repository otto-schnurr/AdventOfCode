//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

//
//  Day03.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/15/2019.
//

import XCTest

final class Day03: XCTestCase {
    
    func test_solution() {
        let lines = parse(paths: _paths)
        let otherLines = parse(paths: _otherPaths)
        var distances = [Int]()

        for line in lines {
            distances += otherLines
                .compactMap { $0.intersect(line) }
                .map { $0.distance(to: .zero) }
        }

        XCTAssertEqual(
            distances.filter { $0 > 0 }.min(), 870
        )

        var length = 0
        distances = []

        for line in lines {
            var otherLength = 0

            distances += otherLines.compactMap { otherLine in
                defer { otherLength += otherLine.length }

                if let intersection = otherLine.intersect(line) {
                    return
                        length + line.start.distance(to: intersection) +
                        otherLength + otherLine.start.distance(to: intersection)
                } else {
                    return nil
                }
            }

            length += line.length
        }

        XCTAssertEqual(
            distances.filter { $0 > 0 }.min(), 13698
        )
    }
    
}


// MARK: - Private Implementation
private struct Point {

    let x: Int
    let y: Int

    static let zero = Point(0, 0)

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    func distance(to other: Point) -> Int {
        return abs(other.x - x) + abs(other.y - y)
    }

}

private enum Direction: String {

    case right = "R"
    case left = "L"
    case up = "U"
    case down = "D"

    func apply(_ amount: Int, to point: Point) -> Point {
        switch self {
        case .right: return Point(point.x + amount, point.y)
        case .left:  return Point(point.x - amount, point.y)
        case .up:    return Point(point.x, point.y + amount)
        case .down:  return Point(point.x, point.y - amount)
        }
    }

    func range(from start: Point, by amount: Int) -> ClosedRange<Int> {
        switch self {
        case .right: return start.x ... start.x + amount
        case .left:  return start.x - amount ... start.x
        case .up:    return start.y ... start.y + amount
        case .down:  return start.y - amount ... start.y
        }
    }

}

private struct Line {

    let start: Point
    let direction: Direction
    let range: ClosedRange<Int>

    var length: Int { range.upperBound - range.lowerBound }
    var end: Point { direction.apply(length, to: start) }

    var intercept: Int {
        switch direction {
        case .up, .down:    return start.x
        case .right, .left: return start.y
        }
    }

    init(from start: Point, direction: Direction, amount: Int) {
        self.start = start
        self.direction = direction
        range = direction.range(from: start, by: amount)
    }

    func intersect(_ other: Line) -> Point? {
        guard
            range.contains(other.intercept) && other.range.contains(intercept)
        else { return nil }

        switch (direction, other.direction) {
            case (.up, .right), (.up, .left), (.down, .left), (.down, .right):
                return Point(intercept, other.intercept)

            case (.right, .up), (.right, .down), (.left, .up), (.left, .down):
                return Point(other.intercept, intercept)

            default:
                return nil
        }
    }

}

private func scan(path: Substring) -> (direction: Direction, amount: Int) {
    let index = path.index(path.startIndex, offsetBy: 1)
    let direction = String(path[..<index])
    let amount = path[index...]
    return (Direction(rawValue: direction)!, Int(amount)!)
}

private func parse(paths: [Substring]) -> [Line] {
    var previousPoint = Point.zero

    return paths.map {
        let (direction, amount) = scan(path: $0)
        let nextPoint = direction.apply(amount, to: previousPoint)
        let line = Line(
            from: previousPoint, direction: direction, amount: amount
        )
        previousPoint = nextPoint
        return line
    }
}


// Private Input
private let (_paths, _otherPaths) = { () -> ([Substring], [Substring]) in
    var lines = try! TestHarnessInput("input03.txt")
    return (
        lines.next()!.split(separator: ","),
        lines.next()!.split(separator: ",")
    )
}()

