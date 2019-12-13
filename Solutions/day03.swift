#!/usr/bin/env swift

struct Point {

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

enum Direction: String {

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

struct Line {

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

func scan(path: Substring) -> (direction: Direction, amount: Int) {
    let index = path.index(path.startIndex, offsetBy: 1)
    let direction = String(path[..<index])
    let amount = path[index...]
    return (Direction(rawValue: direction)!, Int(amount)!)
}

func parse(paths: [Substring]) -> [Line] {
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

let lines = parse(paths: readLine()!.split(separator: ","))
let otherLines = parse(paths: readLine()!.split(separator: ","))
var distances = [Int]()

for line in lines {
    distances += otherLines
        .compactMap { $0.intersect(line) }
        .map { $0.distance(to: .zero) }
}

print("part 1: \(distances.filter { $0 > 0 }.reduce(Int.max, min))")

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

print("part 2: \(distances.filter { $0 > 0 }.reduce(Int.max, min))")
