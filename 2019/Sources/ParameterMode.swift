//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  ParameterMode.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/13/2019.
//

enum ParameterMode: Int {

    case position = 0
    case immediate = 1
    case relative = 2
    
    static func parse(count: Int, from word: Word) -> [ParameterMode] {
        guard count > 0 && word > 0 else { return [] }
        
        let modes = [100, 1_000, 10_000].map { (factor) -> ParameterMode in
            let digit = word % (factor * 10) / factor
            return ParameterMode(rawValue: digit)!
        }
        return Array(modes.prefix(count))
    }

}

extension ParameterMode: CustomStringConvertible {
    var description: String {
        switch self {
        case .position:  return "position"
        case .immediate: return "immediate"
        case .relative:  return "relative"
        }
    }
}
