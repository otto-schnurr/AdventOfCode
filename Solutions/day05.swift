#!/usr/bin/env swift

enum ParameterMode: Int {

    case position = 0
    case immediate = 1

    static func parse(count: Int, from value: Int) -> [ParameterMode] {
        let modes = [100, 1_000, 10_000].map { (factor) -> ParameterMode in
            let digit = value % (factor * 10) / factor
            return ParameterMode(rawValue: digit)!
        }
        return Array(modes.prefix(count))
    }

}

enum Opcode: Int {

    case add = 1
    case multiply = 2
    case input = 3
    case output = 4
    case jump_if_true = 5
    case jump_if_false = 6
    case less_than = 7
    case equals = 8

    var parameterCount: Int {
        switch self {
        case .add, .multiply:
            return 3

        case .input, .output:
            return 1

        case .jump_if_true, .jump_if_false:
            return 2

        case .less_than, .equals:
            return 3
        }
    }

    var storesResult: Bool {
        switch self {
        case .output, .jump_if_true, .jump_if_false:
            return false
        default:
            return true
        }
    }

    func apply(input: [Int], to output: inout Int, index: inout Int) {
        switch self {
        case .add:
            output = input[0] + input[1]

        case .multiply:
            output = input[0] * input[1]

        case .input:
            output = Int(readLine()!)!

        case .output:
            print(input[0])

        case .jump_if_true, .jump_if_false:
            break

        case .less_than:
            output = input[0] < input[1] ? 1 : 0

        case .equals:
            output = input[0] == input[1] ? 1 : 0
        }

        switch self {
        case .jump_if_true:
            if input[0] != 0 {
                index = input[1]
            } else {
                index += parameterCount + 1
            }

        case .jump_if_false:
            if input[0] == 0 {
                index = input[1]
            } else {
                index += parameterCount + 1
            }

        default:
            index += parameterCount + 1
        }
    }

}

extension Array where Element == Int {

    mutating func run() {
        var index = 0

        while let nextIndex = run(at: index) {
            index = nextIndex
        }
    }

    mutating func run(at index: Int) -> Int? {
        var offset = 0
        let word = self[index + offset]
        offset += 1
        guard let opcode = Opcode(rawValue: word % 100) else { return nil }

        let modes = ParameterMode.parse(count: opcode.parameterCount, from: word)

        let parameters = modes.map { (mode) -> Int in
            let word = self[index + offset]
            offset += 1

            switch mode {
            case .position:  return self[word]
            case .immediate: return word
            }
        }

        let outputIndex = opcode.storesResult ? self[index + opcode.parameterCount] : 0
        var newIndex = index

        opcode.apply(
            input: parameters,
            to: &self[outputIndex],
            index: &newIndex
        )

        return newIndex
    }

}

let original = readLine()!.split(separator: ",").map { Int($0)! }

print("part 1:")
var program = original
program.run()

print("part 2:")
program = original
program.run()
