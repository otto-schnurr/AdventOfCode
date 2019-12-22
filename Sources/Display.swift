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


// MARK: Private
private struct Screen {
    
    let width: Int
    let height: Int
    
    subscript(coordinate: Coordinate) -> Display.Pixel {
        get { pixels[coordinate.y][coordinate.x] }
        set(newValue) { pixels[coordinate.y][coordinate.x] = newValue }
    }

    init?(width: Int, height: Int, initialColor: Display.Pixel) {
        guard width > 0 && height > 0 else { return nil }

        self.width = width
        self.height = height
        let row = Array(repeating: initialColor, count: width)
        pixels = Array(repeating: row, count: height)
    }
    
    // MARK: Private
    private var pixels: [[Display.Pixel]]
    
}

private extension Screen {
    
    init?(pixels: [Coordinate: Display.Pixel], backgroundColor: Character) {
        let width = pixels.reduce(0) { max($0, $1.key.x) }
        let height = pixels.reduce(0) { max($0, $1.key.y) }
        guard
            var screen = Screen(
                width: width, height: height, initialColor: backgroundColor
        ) else { return nil }
        
        pixels.forEach { screen[$0] = $1 }
        self = screen
    }
    
}
