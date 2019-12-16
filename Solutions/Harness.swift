//
//  Harness.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/15/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import Foundation

extension URL {
    
    // reference: https://stackoverflow.com/a/58034307/148076
    static func make(testHarnessResource: String) -> URL {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        return thisDirectory
            .appendingPathComponent("Resources")
            .appendingPathComponent(testHarnessResource)
    }
    
}
