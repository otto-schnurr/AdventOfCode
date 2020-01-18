//
//  Grid.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 1/17/2020.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import GameplayKit

public typealias Grid = GKGridGraph<Pixel>

public extension Grid {
    
    typealias Position = vector_int2
    
    var pixels: [Pixel]? {
        guard let nodes = self.nodes else { return nil }
        return nodes.compactMap { $0 as? Pixel }
    }
    
    convenience init(pixels: [Pixel]) {
        let (xRange, yRange) = _ranges(for: pixels.map { $0.gridPosition })
        
        self.init(
            fromGridStartingAt: Position(xRange.lowerBound, yRange.lowerBound),
            width: Int32(xRange.count), height: Int32(yRange.count),
            diagonalsAllowed: false, nodeClass: Pixel.self
        )
        
        var positionsToKeep = Set<Grid.Position>()
        
        for pixel in pixels {
            node(atGridPosition: pixel.gridPosition)?.value = pixel.value
            positionsToKeep.insert(pixel.gridPosition)
        }
        
        if let allPixels = self.pixels {
            let pixelsToRemove = allPixels.filter {
                !positionsToKeep.contains($0.gridPosition)
            }
            remove(pixelsToRemove)
        }
    }
    
    func render(backgroundValue: Pixel.Value = " ") {
        for y in gridOrigin.y ..< gridOrigin.y + Int32(gridHeight) {
            var row = [Pixel.Value](repeating: backgroundValue, count: gridWidth)

            for x in gridOrigin.x ..< gridOrigin.x + Int32(gridWidth) {
                if let pixel = node(atGridPosition: Grid.Position(x, y)) {
                    row[Int(x - gridOrigin.x)] = pixel.value
                }
            }
            
            print(String(row))
        }
    }
    
}

public final class Pixel: GKGridGraphNode {
    
    public typealias Value = Character
    public var value: Value
    
    public override convenience init(gridPosition: Grid.Position) {
        self.init(gridPosition: gridPosition, value: " ")
    }
    
    public init(gridPosition: Grid.Position, value: Value) {
        self.value = value
        super.init(gridPosition: gridPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Private
private typealias PositionRange = Range<Grid.Position.Scalar>

private func _ranges(
    for positions: [Grid.Position]
) -> (xRange: PositionRange, yRange: PositionRange) {
    let xValues = positions.map { $0.x }
    let yValues = positions.map { $0.y }
    
    guard
        let minX = xValues.min(),
        let maxX = xValues.max(),
        let minY = yValues.min(),
        let maxY = yValues.max()
    else { return (0 ..< 0, 0 ..< 0) }
    
    return (Range(minX...maxX), Range(minY...maxY))
}
