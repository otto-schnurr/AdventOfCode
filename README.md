Advent Of Code
==============

[![Platforms](https://img.shields.io/badge/platforms-macOS-important.svg)][Gameplay Kit]
[![Xcode versions](https://img.shields.io/badge/Xcode-11.2-informational.svg)][Xcode versions]
[![Swift versions](https://img.shields.io/badge/swift-5.0-informational.svg)][Swift versions]
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)][license]

[Gameplay Kit]: https://developer.apple.com/documentation/gameplaykit
[Xcode versions]: https://developer.apple.com/xcode/
[Swift versions]: https://docs.swift.org/swift-book/RevisionHistory/RevisionHistory.html
[license]: https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

Otto's solutions for an Advent calendar of [small programming puzzles][advent-of-code] by [Eric Wastl].

Implemented in Swift using the [Swift Package Manager][SPM] and pathfinding from [Gameplay Kit].

Photo by [Annie Spratt].

[advent-of-code]: https://adventofcode.com
[Eric Wastl]: http://was.tl
[SPM]: https://swift.org/package-manager/
[Annie Spratt]: https://unsplash.com/@anniespratt

Usage
-------

### Install ###

    $ git clone git@github.com:otto-schnurr/AdventOfCode.git
    $ cd AdventOfCode

### Test ###

    $ swift test && echo "Solutions have been verified."

### Browse ###

    $ swift package generate-xcodeproj
    $ open AdventOfCode.xcodeproj
