#!/usr/bin/env swift

//  A solution for https://adventofcode.com/2023/day/7
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2023 Otto Schnurr

let translateCard: [Character: Character] = [
    "A": "E", "K": "D", "Q": "C", "J": "B", "T": "A",
]

let translateCardJokers: [Character: Character] = [
    "A": "E", "K": "D", "Q": "C", "J": "0", "T": "A",
]

func encode(hand: String, jokers: Bool) -> String {
    guard hand != "JJJJJ" else { return "5000000"}
    
    let translation = jokers ? translateCardJokers : translateCard
    let encodedHand = hand.map { card in translation[card] ?? card }

    var countForCard: [Character: Int] = [:]
    for card in encodedHand { countForCard[card, default: 0] += 1 }
    
    var sorted = countForCard
        .compactMap { key, value in
            return jokers && key == "0" ? nil : (count: value, card: key)
        }
        .sorted {
            if $0.count == $1.count { return $0.card > $1.card }
            return $0.count > $1.count
        }

    if jokers { sorted[0].count += countForCard["0", default: 0] }

    return sorted.map { String($0.count) }.joined() + String(encodedHand)
}

func winnings(for game: [(hand: String, bid: Int)]) -> Int {
    return game
        .map { $0.bid }
        .enumerated()
        .map { index, bid in (game.count - index) * bid }
        .reduce(0, +)
}

struct StandardInput: Sequence, IteratorProtocol {
    func next() -> String? { return readLine() }
}

let input = StandardInput().map { $0.split(separator: " ") }

let game1 = input
    .map { (hand: encode(hand: String($0[0]), jokers: false), bid: Int($0[1])!) }
    .sorted { $0.hand > $1.hand }
let game2 = input
    .map { (hand: encode(hand: String($0[0]), jokers: true), bid: Int($0[1])!) }
    .sorted { $0.hand > $1.hand }

print("part 1 : \(winnings(for: game1))")
print("part 2 : \(winnings(for: game2))")
