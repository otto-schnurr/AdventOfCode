//
//  Grid.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 1/17/2020.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import GameplayKit

public typealias Grid = GKGridGraph<Pixel>

// MARK: Factory
public extension Grid {
    
    typealias PixelData = [Position: Pixel.Value]
    
    convenience init(data: PixelData) {
        let (xRange, yRange) = _ranges(for: data.map { $0.key })
        
        self.init(
            fromGridStartingAt: Position(xRange.lowerBound, yRange.lowerBound),
            width: Int32(xRange.count), height: Int32(yRange.count),
            diagonalsAllowed: false, nodeClass: Pixel.self
        )
        
        var positionsToKeep = Set<Position>()
        
        for (location, value) in data {
            node(atGridPosition: location)?.value = value
            positionsToKeep.insert(location)
        }
        
        if let allPixels = self.pixels {
            let pixelsToRemove = allPixels.filter {
                !positionsToKeep.contains($0.gridPosition)
            }
            remove(pixelsToRemove)
        }
    }
    
    convenience init(
        pixelValues: [[Pixel.Value]], backgroundValue: Pixel.Value = " "
    ) {
        self.init(
            fromGridStartingAt: .zero,
            width: Int32(pixelValues.first?.count ?? 0),
            height: Int32(pixelValues.count),
            diagonalsAllowed: false, nodeClass: Pixel.self
        )
        
        for (y, row) in pixelValues.enumerated() {
            for (x, value) in row.enumerated() {
                node(atGridPosition: Position(x, y))?.value = value
            }
        }
        
        if let allPixels = pixels {
            let pixelsToRemove = allPixels.filter {
                $0.value == backgroundValue
            }
            remove(pixelsToRemove)
        }
    }

    /// - Parameter lines:
    ///   Pixel values packed into rows that are delimited by newlines.
    convenience init(lines: String, backgroundValue: Pixel.Value = " ") {
        let pixelValues = lines.split(separator: "\n").map { Array($0) }
        self.init(pixelValues: pixelValues, backgroundValue: backgroundValue)
    }
    
    convenience init(
        xRange: Range<Position.Scalar>,
        yRange: Range<Position.Scalar>,
        copiedFrom source: Grid
    ) {
        self.init(
            fromGridStartingAt: Position(xRange.lowerBound, yRange.lowerBound),
            width: xRange.upperBound - xRange.lowerBound,
            height: yRange.upperBound - yRange.lowerBound,
            diagonalsAllowed: false, nodeClass: Pixel.self
        )
        guard let pixels = pixels else { return }

        let validPositions = Set(
            source.pixels?
                .map { $0.gridPosition }
                .filter { xRange.contains($0.x) && yRange.contains($0.y) }
                ?? [ ]
        )
        remove(pixels.filter { !validPositions.contains( $0.gridPosition) })

        // Weird compile errors when attempting forEach { }.
        for sourcePixel in source.pixels ?? [ ] {
            node(atGridPosition: sourcePixel.gridPosition)?.value = sourcePixel.value
        }
    }
    
}

// MARK: Path Finding
public extension Grid {
    
    /// - Parameter node:
    ///   A node encountered by `span()`.
    ///
    /// - Returns: True if the node is considered to be part
    ///   of the spanned path.
    typealias PathFilter = (_ node: NodeType) -> Bool

    /// Calculates the smallest distance needed to traverse the graph.
    ///
    /// More details about [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)
    /// can be found [here](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Shortest%20Path%20(Unweighted)).
    ///
    /// - Parameter startingPosition:
    ///   The position to measure distances from.
    ///
    /// - Parameter pathFilter:
    ///   A closure that decides if a node is part of the path or not.
    ///   The span will not include or travel past nodes that are not
    ///   part of the path.
    ///
    /// - Returns: How far the span had to travel to cover all nodes
    ///   _that could be reached_ from the `startingPosition`.
    func span(
        from startingPosition: Position,
        pathFilter: PathFilter = { _ in true }
    ) -> Int {
        guard
            let start = node(atGridPosition: startingPosition)
        else { return 0 }
        
        var visited = Set([start])
        var queue = [start]
        var distanceTable = [start: 0]
        
        while
            let node = queue.popLast(),
            let distance = distanceTable[node] {

            let adjacentNodes = node.connectedNodes
                .compactMap { $0 as? NodeType }
                .filter { !visited.contains($0) }

            // important: Mark both filtered and unfiltered as visited.
            visited = visited.union(adjacentNodes)

            queue = adjacentNodes.filter(pathFilter) + queue
            adjacentNodes.forEach { distanceTable[$0] = distance + 1 }
        }
        
        return distanceTable.max { $0.value < $1.value }?.value ?? 0
    }
    
}

// MARK: Render
public extension Grid {
    
    var pixels: [Pixel]? {
        guard let nodes = self.nodes else { return nil }
        return nodes.compactMap { $0 as? Pixel }
    }
    
    func render(backgroundValue: Pixel.Value = " ") {
        for y in gridOrigin.y ..< gridOrigin.y + Position.Scalar(gridHeight) {
            var row = [Pixel.Value](repeating: backgroundValue, count: gridWidth)

            for x in gridOrigin.x ..< gridOrigin.x + Position.Scalar(gridWidth) {
                if let pixel = node(atGridPosition: Position(x, y)) {
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
    
    public var connectedPixels: [Pixel] {
        connectedNodes.compactMap { $0 as? Pixel }
    }
    
    public override convenience init(gridPosition: Position) {
        self.init(gridPosition: gridPosition, value: " ")
    }
    
    public init(gridPosition: Position, value: Value) {
        self.value = value
        super.init(gridPosition: gridPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Private
private typealias PositionRange = Range<Position.Scalar>

private func _ranges(
    for positions: [Position]
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
