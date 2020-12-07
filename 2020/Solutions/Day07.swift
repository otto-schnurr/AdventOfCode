//  MIT License
//  Copyright © 2020 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

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
        let rule = Rule(
            rule: "light red bags contain 1 bright white bag, 2 muted yellow bags."
        )
        XCTAssertEqual(rule.bag, "light red")
        XCTAssertEqual(
            rule.contents,
            Set(["bright white", "muted yellow"])
        )
    }

    func test_example() {
        let _ = """
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
    }
    
    func test_solution() {
    }
    
}


// MARK: - Private
private typealias Bag = String

private struct Rule {
    
    let bag: Bag
    let contents: Set<Bag>
    
    init(rule: String) {
        let components = rule
            .filter { $0 != "." && $0 != "," }
            .components(separatedBy: .whitespaces)
            .filter { $0 != "bag" && $0 != "bags" && $0 != "contain" }
        
        bag = components[0...1].joined(separator: " ")
        
        contents = Set(
            stride(from: 3, to: components.count, by: 3).map {
                components[$0...($0+1)].joined(separator: " ")
            }
        )
    }
    
}
