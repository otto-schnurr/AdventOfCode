//
//  Day10.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/18/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest

class Day10: XCTestCase {
    
    func test_coordinateParsing() {
        let map = """
        .#..#
        .....
        #####
        ....#
        ...##
        """
        
        print(parseCoordinates(from: map))
    }
    
}


// MARK: - Private
private struct Coordinate {
    let x: Int
    let y: Int
}

extension Coordinate: CustomStringConvertible {
    var description: String { return "(\(x), \(y))" }
}

private func parseCoordinates(from map: String) -> [Coordinate] {
    // !!!: implement me
    return [Coordinate(x: 0, y: 0)]
}
