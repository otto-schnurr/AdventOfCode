//
//  Day17.swift
//  AdventOfCode/Solutions
//
//  Created by Otto Schnurr on 12/28/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import XCTest
import AdventOfCode

final class Day17: XCTestCase {
    
    func test_solutions() {
        let computer = Computer()
        computer.load(_program)
        computer.run()

        let output = computer.harvestOutputString()
        let screen = Screen(pixels: output.split(separator: "\n").map { Array($0) })!
        screen.render()

        XCTAssertEqual(
            screen.intersections(of: "#").reduce(0) { $0 + $1.x * $1.y },
            9876
        )
    }
    
}


// MARK: - Private
private let _program = Program(testHarnessResource: "input17.txt")!

private extension Screen {
    func intersections(of pixel: Pixel) -> [Coordinate] {
        guard width >= 5 && height >= 5 else { return [ ] }

        let offsets = [
            Coordinate(-1, 0), Coordinate(1, 0),
            Coordinate(0, 0),
            Coordinate(0, -1), Coordinate(0, 1)
        ]
        var result = [Coordinate]()
        
        for x in 2 ..< width - 2 {
            for y in 2 ..< height - 2 {
                let center = Coordinate(x, y)
                let pixelValues = offsets.map { self[center + $0] }
                if pixelValues.allSatisfy({ $0 == "#" }) { result.append(center) }
            }
        }
        
        return result
    }
}
