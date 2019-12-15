//
//  OutputMode.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/15/2019.
//

enum OutputMode: String {
    /// Execution continues after an output is generated.
    case `continue`
    
    /// Execution stops after an output is generated but can be continued later.
    case yield
}
