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
            Reaction(chemical: "A", amount: 10, ingredients: [_oreKey: 10])
        )
        
        XCTAssertEqual(
            Reaction(recipe: "7 A, 1 B => 1 C"),
            Reaction(
                chemical: "C", amount: 1,
                ingredients: ["A": 7, "B": 1]
            )
        )
    }

    func test_examples() {
        var reactions = [
            "10 ORE => 10 A",
            "1 ORE => 1 B",
            "7 A, 1 B => 1 C",
            "7 A, 1 C => 1 D",
            "7 A, 1 D => 1 E",
            "7 A, 1 E => 1 FUEL"
        ].map { Reaction(recipe: $0) }
        var recipes = parseRecipes(from: reactions)
        XCTAssertEqual(
            breakdown([_fuelKey: 1], using: recipes)[_oreKey]!, 31
        )

        reactions = [
            "9 ORE => 2 A",
            "8 ORE => 3 B",
            "7 ORE => 5 C",
            "3 A, 4 B => 1 AB",
            "5 B, 7 C => 1 BC",
            "4 C, 1 A => 1 CA",
            "2 AB, 3 BC, 4 CA => 1 FUEL"
        ].map { Reaction(recipe: $0) }
        recipes = parseRecipes(from: reactions)
        XCTAssertEqual(
            breakdown([_fuelKey: 1], using: recipes)[_oreKey]!, 165
        )
    }
    
}


// MARK: - Private Types
private typealias Chemical = String
private typealias Ingredients = [Chemical: Int]
private typealias RecipeBook = [Chemical: Reaction]

private let _fuelKey = "FUEL"
private let _oreKey = "ORE"

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
    
    static func *(_ factor: Int, _ reaction: Reaction) -> Reaction {
        return Reaction(
            chemical: reaction.chemical,
            amount: factor * reaction.amount,
            ingredients: reaction.ingredients.reduce(Ingredients()) {
                var result = $0
                result[$1.key] = factor * $1.value
                return result
            }
        )
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

private extension Int {
    // reference: https://stackoverflow.com/a/27178435/148076
    func roundedUp(by factor: Self) -> Self {
        let remainder = self % factor
        return remainder == 0 ? self : self + factor - remainder
    }
}


// MARK: - Private Implementation
private func parseRecipes(from reactions: [Reaction]) -> RecipeBook {
    return reactions.reduce(RecipeBook()) {
        var result = $0
        result[$1.chemical] = $1
        return result
    }
}

private func breakdown(
    _ ingredients: Ingredients, using recipes: RecipeBook
) -> Ingredients {
    guard
        ingredients.filter({ $0.key != _oreKey }).count != 0
    else { return ingredients }
    
    var newIngredients = ingredients
    
    for ingredient in ingredients {
        guard
            ingredient.value > 0,
            let reaction = recipes[ingredient.key]
        else { continue }
        assert(reaction.chemical == ingredient.key)

        let factor = ingredient.value.roundedUp(by: reaction.amount) / reaction.amount
        let amount = factor * reaction.amount
        guard amount > 0 else { continue }
        
        if newIngredients[ingredient.key]! == amount {
            newIngredients.removeValue(forKey: ingredient.key)
        } else {
            newIngredients[ingredient.key]! -= amount
        }
        
        newIngredients.merge((factor * reaction).ingredients, uniquingKeysWith: +)
    }
    
    return newIngredients == ingredients ?
        ingredients : breakdown(newIngredients, using: recipes)
}
