//
//  Day14.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/25/2019.
//

import XCTest

class Day14: XCTestCase {

    func test_reactionParsing() {
        XCTAssertEqual(
            Reaction(recipe: "10 ORE => 10 A"),
            Reaction(chemical: "A", amount: 10, ingredients: ["ORE": 10])
        )
        
        XCTAssertEqual(
            Reaction(recipe: "7 A, 1 B => 1 C"),
            Reaction(
                chemical: "C", amount: 1,
                ingredients: ["A": 7, "B": 1]
            )
        )
    }

}


// MARK: - Private
private typealias Chemical = String
private typealias Ingredient = Ingredients.Element
private typealias Ingredients = [Chemical: Int]

private struct Reaction: Hashable {

    let chemical: Chemical
    let amount: Int
    let ingredients: Ingredients

    init(chemical: Chemical, amount: Int, ingredients: Ingredients) {
        self.chemical = chemical
        self.amount = amount
        self.ingredients = ingredients
    }
    
    init(recipe: String) {
        let components = recipe
            .filter { $0 != "," && $0 != "=" && $0 != ">" }
            .split(separator: " ").map { String($0) }
        let allTheThings = stride(from: 0, to: components.count, by: 2).map {
            (chemical: components[$0 + 1], amount: Int(components[$0])!)
        }
        
        chemical = allTheThings.last!.chemical
        amount = allTheThings.last!.amount
        ingredients = allTheThings
            .prefix(allTheThings.count - 1)
            .reduce(Ingredients()) {
                var result = $0
                result[$1.chemical] = $1.amount
                return result
            }
    }
    
}

extension Reaction: CustomStringConvertible {
    var description: String {
        ingredients
            .map { "\($0.value) \($0.key)" }
            .joined(separator: ", ")
        + " => \(amount) \(chemical)"
    }
}
