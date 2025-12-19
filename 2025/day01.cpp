//  A solution for https://adventofcode.com/2025/day/1
//
//  MIT License
//  https://github.com/otto-schnurr/AdventOfCode/blob/main/LICENSE
//  Copyright © 2025 Otto Schnurr

#include <iostream>
#include <charconv>

namespace
{
    const int _dialSize = 100;

    int _parseNumber( std::string line )
    {
        auto suffix = line.substr( 1 );
        int result = 0;
        std::from_chars( suffix.data(), suffix.data() + suffix.size(), result );
        return result;
    }
}

int main()
{
    int dial = 50;
    int part1 = 0;
    int part2 = 0;
    std::string line;

    while ( std::getline( std::cin, line ) )
    {
        const int amount = _parseNumber( line );
        const int wrappedAmount = amount % _dialSize;
        part2 += amount / _dialSize;

        if ( line.front() == 'R' )
        {
            dial += wrappedAmount;
            part2 += dial >= _dialSize ? 1 : 0;
            dial %= _dialSize;
        }
        else
        {
            const int previousDial = dial;
            dial -= wrappedAmount;

            if ( dial < 0 )
            {
                dial += _dialSize;
                part2 += previousDial > 0 ? 1 : 0;
            }

            part2 += dial == 0 ? 1 : 0;
        }

        part1 += dial == 0 ? 1 : 0;
    }

    std::cout << "part 1: " << part1 << std::endl;
    std::cout << "part 2: " << part2 << std::endl;
    return EXIT_SUCCESS;
}
