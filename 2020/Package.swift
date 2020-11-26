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
    products: [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"]),
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
            path: "Tests"
        ),
        .testTarget(
            name: "AdventOfCode-Solutions",
            dependencies: ["AdventOfCode"],
            path: "Solutions"
        )
    ]
)
