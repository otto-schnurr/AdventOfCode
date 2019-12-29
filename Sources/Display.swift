//
//  Display.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/22/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

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
    
    mutating func render() {
        screen = screen ??
            Screen(pixels: initialPixels, backgroundColor: backgroundColor)
        screen?.render()
    }
    
}


// MARK: Private
private final class Screen {
    
    typealias Pixel = Character

    let width: Int
    let height: Int
    
    subscript(coordinate: Coordinate) -> Pixel {
        get { pixels[coordinate.y][coordinate.x] }
        set(newValue) { pixels[coordinate.y][coordinate.x] = newValue }
    }

    init?(width: Int, height: Int, initialColor: Pixel) {
        guard width > 0 && height > 0 else { return nil }

        self.width = width
        self.height = height
        let row = Array(repeating: initialColor, count: width)
        pixels = Array(repeating: row, count: height)
    }
    
    // MARK: Private
    private var pixels: [[Pixel]]
    
}

private extension Screen {
    
    convenience init?(pixels: [Coordinate: Screen.Pixel], backgroundColor: Character) {
        let width = pixels.reduce(0) { max($0, $1.key.x) } + 1
        let height = pixels.reduce(0) { max($0, $1.key.y) } + 1
        self.init(width: width, height: height, initialColor: backgroundColor)
        pixels.forEach { self[$0] = $1 }
    }
    
    func render() { pixels.forEach { print(String($0)) } }
    
}
