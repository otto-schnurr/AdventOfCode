#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2023/day/7
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2023 Otto Schnurr

let translateCard: [Character: Character] = [
    "A": "E", "K": "D", "Q": "C", "J": "B", "T": "A",
]

func encode(hand: String.SubSequence) -> String {
    let encodedHand = hand.map { card in translateCard[card] ?? card }

    var countForCard: [Character: Int] = [:]
    for card in encodedHand {
        countForCard[card, default: 0] += 1
    }
    let sorted = countForCard
        .map { key, value in (count: value, card: key) }
        .sorted {
            if $0.count == $1.count { return $0.card > $1.card }
            return $0.count > $1.count
        }
    
    return sorted.map { String($0.count) }.joined() + String(encodedHand)
}

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let game = StandardInput()
    .map { $0.split(separator: " ") }
    .map { (hand: encode(hand: $0[0]), bid: Int($0[1])!) }
    .sorted { $0.hand > $1.hand }

let part1 = game
    .map { $0.bid }
    .enumerated()
    .map { index, bid in (game.count - index) * bid }

print("part 1 : \(part1.reduce(0, +))")
