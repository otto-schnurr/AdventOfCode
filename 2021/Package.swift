// swift-tools-version:5.5

//
//  Package.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/1/2021.
//  Copyright © 2021 Otto Schnurr. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-algorithms",
            .upToNextMinor(from: "1.0.0")
        ),
    ],
    targets: [
        .target(
            name: "AdventOfCode",
            dependencies: [ ],
            path: "Sources"
        ),
        .testTarget(
            name: "AdventOfCode-Solutions",
            dependencies: [
                "AdventOfCode",
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            path: "Solutions",
            resources: [.process("Input")]
        )
    ]
)
