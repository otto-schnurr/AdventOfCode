//
//  Display.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/22/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

public struct Display {
    
    typealias Pixel = Character
    
    subscript(coordinate: Coordinate) -> Pixel {
        get {
            if let screen = screen {
                return screen[coordinate.y][coordinate.x]
            } else {
                return initialPixels[coordinate] ?? backgroundColor
            }
        }
        set(newValue) {
            if var screen = screen {
                screen[coordinate.y][coordinate.x] = newValue
            } else {
                initialPixels[coordinate] = newValue
            }
        }
    }
    
    init(backgroundColor: Pixel) {
        self.backgroundColor = backgroundColor
    }
    
    // MARK: Private
    private typealias Screen = [[Pixel]]
    private let backgroundColor: Pixel
    private var initialPixels = [Coordinate: Pixel]()
    private var screen: Screen?
    
}

