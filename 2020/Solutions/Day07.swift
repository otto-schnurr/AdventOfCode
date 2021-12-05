//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  Day07.swift
//  AdventOfCode-Solutions
//
//  A solution for https://adventofcode.com/2020/day/7
//  Created by Otto Schnurr on 12/6/2020.
//

import XCTest

final class Day07: XCTestCase {

    func test_ruleParsing() {
        var rule = Rule("light red bags contain 1 bright white bag, 2 muted yellow bags.")
        XCTAssertEqual(rule.bag, "light red")
        XCTAssertEqual(
            rule.ingredients,
            [Ingredient(bag: "bright white", count: 1), Ingredient(bag: "muted yellow", count: 2)]
        )
        
        rule = Rule("faded blue bags contain no other bags.")
        XCTAssertEqual(rule.bag, "faded blue")
        XCTAssertEqual(rule.ingredients, [ ])
    }

    func test_first_example() {
        let data = """
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
        """
        let rules = data.components(separatedBy: .newlines).map { Rule($0) }
        
        let parentMap = _parseParentMap(from: rules)
        XCTAssertEqual(
            _nestedContainers(for: "shiny gold", using: parentMap).count,
            4
        )
        
        let ingredientMap = _parseIngredientMap(from: rules)
        XCTAssertEqual(
            _nestedIngredientCount(for: "shiny gold", using: ingredientMap) - 1,
            32
        )
    }

    func test_second_example() {
        let data = """
        shiny gold bags contain 2 dark red bags.
        dark red bags contain 2 dark orange bags.
        dark orange bags contain 2 dark yellow bags.
        dark yellow bags contain 2 dark green bags.
        dark green bags contain 2 dark blue bags.
        dark blue bags contain 2 dark violet bags.
        dark violet bags contain no other bags.
        """
        let rules = data.components(separatedBy: .newlines).map { Rule($0) }
        
        let ingredientMap = _parseIngredientMap(from: rules)
        XCTAssertEqual(
            _nestedIngredientCount(for: "shiny gold", using: ingredientMap) - 1,
            126
        )
    }
    
    func test_solution() {
        let rules = Array(TestHarnessInput("input07.txt")!).map { Rule($0) }
        
        let parentMap = _parseParentMap(from: rules)
        XCTAssertEqual(
            _nestedContainers(for: "shiny gold", using: parentMap).count,
            242
        )
        
        let ingredientMap = _parseIngredientMap(from: rules)
        XCTAssertEqual(
            _nestedIngredientCount(for: "shiny gold", using: ingredientMap) - 1,
            176_035
        )
    }
    
}


// MARK: - Private
private typealias Bag = String
private typealias ParentMap = [Bag: Set<Bag>]
private typealias IngredientMap = [Bag: [Ingredient]]

private struct Ingredient: Hashable {
    let bag: Bag
    let count: Int
}

private struct Rule {
    
    let bag: Bag
    let ingredients: [Ingredient]
    
    init(_ rule: String) {
        let components = rule
            .filter { $0 != "." && $0 != "," }
            .components(separatedBy: .whitespaces)
            .filter { $0 != "bag" && $0 != "bags" && $0 != "contain" }
        
        bag = components[0...1].joined(separator: " ")
        
        var ingredients = [Ingredient]()
        
        if components[2...3].joined(separator: " ") == "no other" {
            ingredients = [ ]
        } else {
            ingredients = stride(from: 2, to: components.count, by: 3).map { index in
                let bag = components[(index + 1)...(index+2)].joined(separator: " ")
                return Ingredient(bag: bag, count: Int(components[index])!)
            }
        }
        
        self.ingredients = ingredients
    }
    
}

private func _parseParentMap(from rules: [Rule]) -> ParentMap {
    var result = ParentMap()
    rules.forEach { rule in
        rule.ingredients.forEach { ingredient in
            let parents = result[ingredient.bag] ?? Set<Bag>()
            result[ingredient.bag] = parents.union(Set([rule.bag]))
        }
    }
    return result
}

private func _nestedContainers(for bag: Bag, using map: ParentMap) -> Set<Bag> {
    let containers = map[bag] ?? Set<Bag>()
    let nestedContainers = containers.reduce(Set<Bag>()) { result, container in
        result.union(_nestedContainers(for: container, using: map))
    }
    return containers.union(nestedContainers)
}

private func _parseIngredientMap(from rules: [Rule]) -> IngredientMap {
    var result = IngredientMap()
    rules.forEach { result[$0.bag] = $0.ingredients }
    return result
}

private func _nestedIngredientCount(for bag: Bag, using map: IngredientMap) -> Int {
    let ingredients = map[bag] ?? [ ]
    
    return 1 + ingredients.reduce(0) { result, ingredient in
        result + ingredient.count * _nestedIngredientCount(for: ingredient.bag, using: map)
    }
}

