// swift-tools-version:5.3

//
//  Package.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 11/26/2020.
//  Copyright © 2020 Otto Schnurr. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-algorithms",
            .upToNextMinor(from: "0.0.1")
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
