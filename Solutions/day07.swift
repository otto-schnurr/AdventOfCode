#!/usr/bin/env swift sh

import AdventOfCode // ..

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

func runAmplifier(phase: Int, source: Int) -> Int {
    let computer = Computer(program: original)
    computer.inputBuffer = [phase, source]
    computer.run()
    return computer.outputBuffer[0]
}

func run(phases: [Int]) -> Int {
    return phases.reduce(0) { runAmplifier(phase: $1, source: $0) }
}

print(permutations.map(run).reduce(0,max))
