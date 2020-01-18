//
//  Grid.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 1/17/2020.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import GameplayKit

public typealias Grid = GKGridGraph<Pixel>

public final class Pixel: GKGridGraphNode {
    
    public var value: Character
    
    public override convenience init(gridPosition: vector_int2) {
        self.init(gridPosition: gridPosition, value: " ")
    }
    
    public init(gridPosition: vector_int2, value: Character) {
        self.value = value
        super.init(gridPosition: gridPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public extension Grid {
    var pixels: [Pixel]? {
        guard let nodes = self.nodes else { return nil }
        return nodes.compactMap { $0 as? Pixel }
    }
}
