// swift-tools-version:5.1

//
//  Package.swift
//  AdventOfCode
//
//  Created by Otto Schnurr on 12/12/2019.
//  Copyright © 2016 Otto Schnurr. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    products: [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"])
    ],
    targets: [
        .target(name: "AdventOfCode", dependencies: []),
        .testTarget(
            name: "AdventOfCode-UnitTests",
            dependencies: ["AdventOfCode"],
            path: "Tests"
        )
    ]
)
