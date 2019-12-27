//
//  Day14.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/25/2019.
//

import XCTest

class Day14: XCTestCase {

}


// MARK: - Private
private typealias Chemical = String
private typealias Ingredient = Ingredients.Element
private typealias Ingredients = [Chemical: Int]

private struct Reaction: Hashable {

    let chemical: Chemical
    let amount: Int
    let ingredients: Ingredients

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
