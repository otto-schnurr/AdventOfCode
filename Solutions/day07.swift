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

final class ProgramContext {

    init(program: [Int]) {
        self.program = program
    }

    func addInput(_ input: Int) {
        inputBuffer.append(input)
    }

    func popInput() -> Int {
        return inputBuffer.remove(at: 0)
    }

    func processOutput(_ output: Int) {
        outputBuffer.append(output)
    }

    func run() -> Int {
        while let nextIndex = program.run(at: index, context: self) {
            index = nextIndex
        }

        return outputBuffer[0]
    }

    private var index = 0
    private var program: [Int]
    private var inputBuffer = [Int]()
    private var outputBuffer = [Int]()

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

    func apply(
        input: [Int], to output: inout Int, index: inout Int,
        context: ProgramContext
    ) {
        switch self {
        case .add:
            output = input[0] + input[1]

        case .multiply:
            output = input[0] * input[1]

        case .input:
            output = context.popInput()

        case .output:
            context.processOutput(input[0])

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

    mutating func incrementBase5() -> Bool {
        guard !isEmpty else { return false }

        self[count - 1] += 1

        (1 ..< count).reversed().forEach { index in
            self[index - 1] += self[index] / 5
            self[index] %= 5
        }

        return self[0] < 5
    }

    mutating func run(at index: Int, context: ProgramContext) -> Int? {
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
            index: &newIndex,
            context: context
        )

        return newIndex
    }

}

var permutations = [[Int]]()

func permuteWirth(_ a: [Int], _ n: Int) {
    if n == 0 {
        permutations.append(a)
    } else {
        var a = a
        permuteWirth(a, n - 1)
        for i in 0..<n {
            a.swapAt(i, n)
            permuteWirth(a, n - 1)
            a.swapAt(i, n)
        }
    }
}

permuteWirth([0, 1, 2, 3, 4], 4)

struct PhaseCombinations: Sequence, IteratorProtocol {

    var combination = [0, 0, 0, 0, 0]

    mutating func next() -> [Int]? {
        let result = combination
        guard !result.isEmpty else { return nil }

        if !combination.incrementBase5() { combination = [] }

        return result
    }

}

let original = readLine()!.split(separator: ",").map { Int($0)! }

func runAmplifier(phase: Int, input: Int) -> Int {
    let context = ProgramContext(program: original)
    context.addInput(phase)
    context.addInput(input)

    return context.run()
}

func run(phases: [Int]) -> Int {
    return phases.reduce(0) { runAmplifier(phase: $1, input: $0) }
}

print(permutations.map(run).reduce(0,max))
