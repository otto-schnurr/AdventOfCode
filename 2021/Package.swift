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
    products: [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"]),
    ],
    targets: [
        .target(name: "AdventOfCode", dependencies: [ ]),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: ["AdventOfCode"],
            path: "Tests"
        )
    ]
)
