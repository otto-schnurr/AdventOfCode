//
//  Screen+Search.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/31/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public extension Screen {
    
    /// - Parameter pixel:
    ///   The value of the pixel in question.
    ///
    /// - Parameter distance:
    ///   How far away the pixel in question is from the starting position.
    ///
    /// - Returns:True if the specified pixel is considered to be part
    ///   of the current path.
    typealias PathHandler = (_ pixel: Pixel, _ distance: Int) -> Bool

    func firstCoordinate(where predicate: (Pixel) -> Bool) -> Coordinate? {
        let search = pixels.map { $0.firstIndex { predicate($0) } }
        guard
            let y = search.firstIndex(where: { $0 != nil }),
            let _x = search.first(where: { $0 != nil }),
            let x = _x
        else { return nil }
        
        return Coordinate(x, y)
    }
    
    /// Calculates the smallest distance needed to cover a path of pixels.
    ///
    /// Only orthogonal pixels are considered adjacent.
    /// Diagonal pixels are not.
    ///
    /// - Parameter startingPosition:
    ///   The position to measure distances from.
    ///
    /// - Parameter pixelIsPartOfPath:
    ///   A closure that decides if a pixel value is part of the path
    ///   or not. Adjacent pixels that a designated as path pixels by this
    ///   closure are considered connected.
    ///
    /// - Returns: How far the span had to travel to cover all pixels
    ///   that are connected on the pathway.
    func spanPath(
        from startingPosition: Coordinate,
        pathHandler: PathHandler
    ) -> Int {
        var visitedCoordinates = Set<Coordinate>()
        var queue = [startingPosition]
        var distanceTable = [startingPosition: 0]
        
        while
            let position = queue.popLast(),
            let distance = distanceTable[position] {
            
            let adjacentPositions = Direction.all.map {
                position + $0
            }.filter {
                self.validate(coordinate: $0) && !visitedCoordinates.contains($0)
            }
                
            visitedCoordinates = visitedCoordinates.union(adjacentPositions)
            let adjacentPaths = adjacentPositions.filter {
                pathHandler(self[$0], distance + 1)
            }
            queue = adjacentPaths + queue
            adjacentPaths.forEach { distanceTable[$0] = distance + 1 }
        }
        
        return distanceTable.max { $0.value < $1.value }?.value ?? 0
    }

}
