//
//  Computer+String.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public extension Computer {
    
    func appendInput(string: String) {
        inputBuffer += string.utf8.map { Word($0) }
    }
    
    func harvestOutputString() -> String {
        let characters = harvestOutput()
            .compactMap { UnicodeScalar($0) }
            .map { Character($0) }
        return String(characters)
    }
    
    func harvestOutputLine() -> String {
        assert(
            outputMode == .yield,
            "This method is designed for a specific use."
        )
        var characters = Array(harvestOutputString())
        while characters.last != Character("\n") {
            run()
            characters += harvestOutputString()
        }
        guard !characters.isEmpty else { return "" }
        
        // Strip off the newline.
        return String(characters.prefix(characters.count - 1))
    }

}
