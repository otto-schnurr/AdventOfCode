//
//  Screen+Search.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public extension Screen {
    func firstCoordinate(where predicate: (Pixel) -> Bool) -> Coordinate? {
        let search = pixels.map { $0.firstIndex { predicate($0) } }
        guard
            let y = search.firstIndex(where: { $0 != nil }),
            let _x = search.first(where: { $0 != nil }),
            let x = _x
        else { return nil }
        
        return Coordinate(x, y)
    }
}
