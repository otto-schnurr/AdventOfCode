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

    func test_examples_part1() {
        var reactions = [
            "10 ORE => 10 A",
            "1 ORE => 1 B",
            "7 A, 1 B => 1 C",
            "7 A, 1 C => 1 D",
            "7 A, 1 D => 1 E",
            "7 A, 1 E => 1 FUEL"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(oreNeeded(forFuel: 1, using: reactions)!, 31)

        reactions = [
            "9 ORE => 2 A",
            "8 ORE => 3 B",
            "7 ORE => 5 C",
            "3 A, 4 B => 1 AB",
            "5 B, 7 C => 1 BC",
            "4 C, 1 A => 1 CA",
            "2 AB, 3 BC, 4 CA => 1 FUEL"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(oreNeeded(forFuel: 1, using: reactions)!, 165)
        
        reactions = [
            "157 ORE => 5 NZVS",
            "165 ORE => 6 DCFZ",
            "44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL",
            "12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ",
            "179 ORE => 7 PSHF",
            "177 ORE => 5 HKGWZ",
            "7 DCFZ, 7 PSHF => 2 XJWVT",
            "165 ORE => 2 GPVTF",
            "3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(oreNeeded(forFuel: 1, using: reactions)!, 13_312)
        
        reactions = [
            "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG",
            "17 NVRVD, 3 JNWZP => 8 VPVL",
            "53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL",
            "22 VJHF, 37 MNCFX => 5 FWMGM",
            "139 ORE => 4 NVRVD",
            "144 ORE => 7 JNWZP",
            "5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC",
            "5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV",
            "145 ORE => 6 MNCFX",
            "1 NVRVD => 8 CXFTF",
            "1 VJHF, 6 MNCFX => 4 RFSQX",
            "176 ORE => 6 VJHF"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(oreNeeded(forFuel: 1, using: reactions)!, 180_697)
        
        reactions = [
            "171 ORE => 8 CNZTR",
            "7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL",
            "114 ORE => 4 BHXH",
            "14 VRPVC => 6 BMBT",
            "6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL",
            "6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT",
            "15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW",
            "13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW",
            "5 BMBT => 4 WPTQ",
            "189 ORE => 9 KTJDG",
            "1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP",
            "12 VRPVC, 27 CNZTR => 2 XDBXC",
            "15 KTJDG, 12 BHXH => 5 XCVML",
            "3 BHXH, 2 VRPVC => 7 MZWV",
            "121 ORE => 7 VRPVC",
            "7 XCVML => 6 RJRHP",
            "5 BHXH, 4 VRPVC => 5 LTCX"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(oreNeeded(forFuel: 1, using: reactions)!, 2_210_736)
    }
    
    func test_examples_part2() {
        let availableOre = 1_000_000_000_000
        
        var reactions = [
            "157 ORE => 5 NZVS",
            "165 ORE => 6 DCFZ",
            "44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL",
            "12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ",
            "179 ORE => 7 PSHF",
            "177 ORE => 5 HKGWZ",
            "7 DCFZ, 7 PSHF => 2 XJWVT",
            "165 ORE => 2 GPVTF",
            "3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(
            fuelProduced(fromOre: availableOre, using: reactions)!, 82_892_753
        )
        
        reactions = [
            "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG",
            "17 NVRVD, 3 JNWZP => 8 VPVL",
            "53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL",
            "22 VJHF, 37 MNCFX => 5 FWMGM",
            "139 ORE => 4 NVRVD",
            "144 ORE => 7 JNWZP",
            "5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC",
            "5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV",
            "145 ORE => 6 MNCFX",
            "1 NVRVD => 8 CXFTF",
            "1 VJHF, 6 MNCFX => 4 RFSQX",
            "176 ORE => 6 VJHF"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(
            fuelProduced(fromOre: availableOre, using: reactions)!, 5_586_022
        )

        reactions = [
            "171 ORE => 8 CNZTR",
            "7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL",
            "114 ORE => 4 BHXH",
            "14 VRPVC => 6 BMBT",
            "6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL",
            "6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT",
            "15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW",
            "13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW",
            "5 BMBT => 4 WPTQ",
            "189 ORE => 9 KTJDG",
            "1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP",
            "12 VRPVC, 27 CNZTR => 2 XDBXC",
            "15 KTJDG, 12 BHXH => 5 XCVML",
            "3 BHXH, 2 VRPVC => 7 MZWV",
            "121 ORE => 7 VRPVC",
            "7 XCVML => 6 RJRHP",
            "5 BHXH, 4 VRPVC => 5 LTCX"
        ].map { Reaction(recipe: $0) }
        XCTAssertEqual(
            fuelProduced(fromOre: availableOre, using: reactions)!, 460_664
        )
    }
    
    func test_solutions() {
        let reactions =
            try! TestHarnessInput("input14.txt").map { Reaction(recipe: $0 ) }
        let recipes = parseRecipes(from: reactions)
        XCTAssertEqual(
            breakdown([_fuelKey: 1], using: recipes)[_oreKey]!, 443537
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
private func oreNeeded(forFuel fuelTarget: Int, using reactions: [Reaction]) -> Int? {
    let recipes = parseRecipes(from: reactions)
    return breakdown([_fuelKey: fuelTarget], using: recipes)[_oreKey]
}

private func fuelProduced(
    fromOre availableOre: Int, using reactions: [Reaction]
) -> Int? {
    guard
        let oreForOneFuel = oreNeeded(forFuel: 1, using: reactions),
        oreForOneFuel > 0
    else { return nil }
    
    let estimatedFuel = availableOre / oreForOneFuel
    let (fuelA, fuelB) = (estimatedFuel / 2, 2 * estimatedFuel)
    guard
        let oreA = oreNeeded(forFuel: fuelA, using: reactions),
        let oreB = oreNeeded(forFuel: fuelB, using: reactions)
    else { return nil }

    let slope = Double(fuelB - fuelA) / Double(oreB - oreA)
    return fuelA + Int(slope * Double(availableOre - oreA))
}

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
