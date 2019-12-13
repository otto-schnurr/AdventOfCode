//
//  ParameterMode.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

enum ParameterMode: Int {

    case position = 0
    case immediate = 1

    static func parse(count: Int, from value: Int) -> [ParameterMode] {
        let modes = [100, 1_000, 10_000].map { (factor) -> ParameterMode in
            let digit = value % (factor * 10) / factor
            return ParameterMode(rawValue: digit)!
        }
        return Array(modes.prefix(count))
    }

}
