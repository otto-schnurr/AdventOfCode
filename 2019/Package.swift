// swift-tools-version:5.5

//
//  Package.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/12/2019.
//  Copyright © 2019 Otto Schnurr
//

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [ .macOS(.v10_12) ],
    products: [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"])
    ],
    targets: [
        .target(
            name: "AdventOfCode",
            dependencies: [ ],
            path: "Sources"
        ),
        .testTarget(
            name: "AdventOfCode-UnitTests",
            dependencies: ["AdventOfCode"],
            path: "Tests"
        ),
        .testTarget(
            name: "AdventOfCode-Solutions",
            dependencies: ["AdventOfCode"],
            path: "Solutions",
            resources: [.process("Input")]
        )
    ]
)
