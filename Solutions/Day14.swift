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

    func test_examples() {
        let reactions = [
            "10 ORE => 10 A",
            "1 ORE => 1 B",
            "7 A, 1 B => 1 C",
            "7 A, 1 C => 1 D",
            "7 A, 1 D => 1 E",
            "7 A, 1 E => 1 FUEL"
        ].map { Reaction(recipe: $0) }
        let recipes = parseRecipes(from: reactions)
        XCTAssertEqual(
            breakdown(["FUEL": 1], using: recipes)["ORE"]!, 31
        )
    }
    
}


// MARK: - Private
private typealias Chemical = String
private typealias Ingredient = Ingredients.Element
private typealias Ingredients = [Chemical: Int]
private typealias RecipeBook = [Chemical: Reaction]

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

private func parseRecipes(from reactions: [Reaction]) -> RecipeBook {
    return reactions.reduce(RecipeBook()) {
        var result = $0
        result[$1.chemical] = $1
        return result
    }
}

private func breakdown(
    _ ingredients: Ingredients,
    using recipes: RecipeBook,
    useExactAmounts: Bool = true
) -> Ingredients {
    var newIngredients = ingredients
    
    for ingredient in ingredients {
        guard
            let reaction = recipes[ingredient.key],
            ingredient.value >= reaction.amount || !useExactAmounts
        else { continue }
        assert(reaction.chemical == ingredient.key)
        
        if newIngredients[ingredient.key]! <= reaction.amount {
            newIngredients.removeValue(forKey: ingredient.key)
        } else {
            newIngredients[ingredient.key]! -= reaction.amount
        }
        
        newIngredients.merge(reaction.ingredients) { $0 + $1 }
    }
    
    if newIngredients != ingredients {
        return breakdown(newIngredients, using: recipes)
    } else if useExactAmounts {
        return breakdown(ingredients, using: recipes, useExactAmounts: false)
    } else {
        return ingredients
    }
}
