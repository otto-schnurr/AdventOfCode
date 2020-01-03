//
//  Screen.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/22/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

/// A grid of pixels with a known size and accessed using coordinates.
public final class Screen {
    
    public typealias Pixel = Character

    public let width: Int
    public let height: Int
    
    public init?(pixels: [[Pixel]]) {
        guard !pixels.isEmpty && pixels.first?.isEmpty == false else { return nil }

        height = pixels.count
        width = pixels[0].count
        self.pixels = pixels
        assert(width > 0)
        assert(height > 0)
    }
    
    // MARK: Internal
    internal var pixels: [[Pixel]]

}

public extension Screen {
    
    subscript(coordinate: Coordinate) -> Pixel {
        get { pixels[coordinate.y][coordinate.x] }
        set(newValue) { pixels[coordinate.y][coordinate.x] = newValue }
    }

    convenience init?(width: Int, height: Int, initialColor: Pixel) {
        guard width > 0 && height > 0 else { return nil }
        let row = Array(repeating: initialColor, count: width)
        let pixels = Array(repeating: row, count: height)
        self.init(pixels: pixels)
    }
    
    /// - Parameter lines:
    ///   Pixel packed into rows that are delimited by newlines.
    convenience init?(lines: String) {
        let pixels = lines.split(separator: "\n").map { Array($0) }
        self.init(pixels: pixels)
    }
    
    func copy() -> Screen {
        assert(!pixels.isEmpty)
        assert(pixels.first?.isEmpty == false)
        return Screen(pixels: pixels)!
    }
    
    func validate(coordinate: Coordinate) -> Bool {
        return
            0 <= coordinate.x && coordinate.x < width &&
            0 <= coordinate.y && coordinate.y < height
    }
    
    func render() { pixels.forEach { print(String($0)) } }
    
}
