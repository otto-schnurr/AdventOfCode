#!/usr/bin/env swift

struct Input: Sequence, IteratorProtocol {
    func next() -> (parent: String, child: String)? {
        guard let line = readLine() else { return nil }
        let components = line.split(separator: ")")
        return (String(components[0]), String(components[1]))
    }
}

typealias Parent = String
typealias Children = [String]
var data = [Parent: Children]()

Input().forEach {
    if data[$0.parent] == nil {
        data[$0.parent] = []
    }

    data[$0.parent]!.append($0.child)
}

func checksum(parent: Parent, from previousCount: Int) -> Int {
    guard let children = data[parent] else {
        return previousCount
    }

    return previousCount + children.reduce(0) {
        $0 + checksum(parent: $1, from: previousCount + 1)
    }
}

print("part 1: \(checksum(parent: "COM", from: 0))")

func path(to target: String, from previousPath: [String]) -> [String] {
    let parent = previousPath.last!
    if parent == target {  return previousPath }

    guard let children = data[parent] else { return [] }

    return children
        .map { path(to: target, from: previousPath + [$0])}
        .first { !$0.isEmpty } ?? []
}

let santaPath = path(to: "SAN", from: ["COM"])
let myPath = path(to: "YOU", from: ["COM"])

let commonPathLength = (1 ..< santaPath.count).reversed().first {
    myPath.starts(with: santaPath[0...$0])
}!

print("part 2: \(santaPath.count + myPath.count - 2 * commonPathLength - 4)")
