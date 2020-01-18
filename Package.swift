// swift-tools-version:5.1

//
//  Package.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/12/2019.
//  Copyright © 2019 Otto Schnurr. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [ .macOS(.v10_11) ],
    products: [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"])
    ],
    targets: [
        .target(
            name: "AdventOfCode",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "AdventOfCode-UnitTests",
            dependencies: ["AdventOfCode"],
            path: "Solutions"
        )
    ]
)
