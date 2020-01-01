//
//  Screen+Search.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public extension Screen {
    
    typealias CoordinateHandler = (_ coordinate: Coordinate, _ distance: Int) -> Void
    
    func firstCoordinate(where predicate: (Pixel) -> Bool) -> Coordinate? {
        let search = pixels.map { $0.firstIndex { predicate($0) } }
        guard
            let y = search.firstIndex(where: { $0 != nil }),
            let _x = search.first(where: { $0 != nil }),
            let x = _x
        else { return nil }
        
        return Coordinate(x, y)
    }
    
    /// Calculates the smallest distance needed to cover connected pixels.
    ///
    /// Only orthogonal pixels are considered adjacent.
    /// Diagonal pixels are not.
    ///
    /// - Parameter startingPosition:
    ///   The position to measure distances from.
    ///
    /// - Parameter path:
    ///   The pixel value to traverse. Adjacent pixels of this value are
    ///   considered connected.
    ///
    ///   - Parameter offPathHandler:
    ///   Called for every adjacent pixel that is encountered that is not
    ///   part of the path.
    ///
    /// - Returns: How far the search had to travel to cover all
    ///   connected pixels.
    func distanceRequired(
        from startingPosition: Coordinate,
        toCover path: Pixel,
        offPathHandler: CoordinateHandler? = nil
    ) -> Int {
        var offPathVisited = Set<Coordinate>()
        var queue = [startingPosition]
        var distanceTable = [startingPosition: 0]
        
        while
            let position = queue.popLast(),
            let distance = distanceTable[position] {
            
            let adjacentPositions = Direction.all
                .map { position + $0 }
                .filter { self.validate(coordinate: $0) }
            
            if let handler = offPathHandler {
                adjacentPositions
                    .filter { self[$0] != path }
                    .filter { !offPathVisited.contains($0) }
                    .forEach {
                        handler($0, distance + 1)
                        offPathVisited.insert($0)
                    }
            }
                
            let adjacentPaths = adjacentPositions
                .filter { self[$0] == path }
                .filter { !distanceTable.keys.contains($0) }
            queue = adjacentPaths + queue
            adjacentPaths.forEach { distanceTable[$0] = distance + 1 }
        }
        
        return distanceTable.max { $0.value < $1.value }?.value ?? 0
    }

}
