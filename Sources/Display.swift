//
//  Display.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/22/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

/// A grid of pixels of unknown size.
public struct Display {
    
    public typealias Pixel = Character
    
    public subscript(coordinate: Coordinate) -> Pixel {
        get {
            if let screen = screen {
                return screen[coordinate]
            } else {
                return initialPixels[coordinate] ?? backgroundColor
            }
        }
        set(newValue) {
            if let screen = screen {
                screen[coordinate] = newValue
            } else {
                initialPixels[coordinate] = newValue
            }
        }
    }
    
    public init(backgroundColor: Pixel) {
        self.backgroundColor = backgroundColor
    }
    
    // MARK: Private
    private let backgroundColor: Pixel
    private var initialPixels = [Coordinate: Pixel]()
    private var screen: Screen?
    
}

public extension Display {
    
    var initialPixelCount: Int { return initialPixels.count }
    
    func initialPixelCount(for character: Character) -> Int {
        return initialPixels.filter { $0.value == character }.count
    }
    
    mutating func export() -> Screen? { return resolveScreen()?.copy() }
    
    /// - Note: Initial pixel counts become locked after calling this method.
    mutating func render() { resolveScreen()?.render() }
    
}


// MARK: - Private
private extension Display {
    mutating func resolveScreen() -> Screen? {
        screen = screen ??
            Screen(pixels: initialPixels, backgroundColor: backgroundColor)
        return screen
    }
}

private extension Screen {
    
    convenience init?(pixels: [Coordinate: Screen.Pixel], backgroundColor: Character) {
        let width = pixels.reduce(0) { max($0, $1.key.x) } + 1
        let height = pixels.reduce(0) { max($0, $1.key.y) } + 1
        self.init(width: width, height: height, initialColor: backgroundColor)
        pixels.forEach { self[$0] = $1 }
    }
    
}
