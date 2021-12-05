//  MIT License
//  Copyright © 2019 Otto Schnurr
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE

//
//  OutputMode.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/15/2019.
//

public enum OutputMode: String {
    /// Execution continues after an output is generated.
    case `continue`
    
    /// Execution stops after an output is generated but can be continued later.
    case yield
}
