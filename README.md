Advent Of Code
==============

[![Xcode versions](https://img.shields.io/badge/macOS-15.7-informational.svg)][macOS versions]
[![Clang versions](https://img.shields.io/badge/clang-17.0.0-informational.svg)][Clang versions]
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)][license]

[macOS versions]: https://support.apple.com/en-us/109033
[Clang versions]: https://clang.llvm.org/cxx_status.html
[license]: https://github.com/otto-schnurr/AdventOfCode/blob/master/LICENSE

Solutions to [Advent of Code][advent-of-code] programming puzzles implemented in Swift.

[advent-of-code]: https://adventofcode.com

Usage
-----

### Mac Compiler ###

Verify

```sh
clang++ --version
make --version
```

If necessary, set up the compiler using [Xcode command-line tools][Xcode].

    xcode-select --install

[Xcode]: https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/

### Code ###

    git clone git@github.com:otto-schnurr/AdventOfCode.git
    cd AdventOfCode/2025

### Execution Example ###

    make day01
    ...
    ./day01 < input.txt
