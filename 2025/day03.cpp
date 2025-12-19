#include <iostream>
#include <algorithm>
#include <charconv>

using Joltage = long;

namespace
{
    Joltage _processLine( const std::string& line, size_t width )
    {
        std::string word;
        auto prefixBegin = line.cbegin();
        auto prefixEnd = line.cend() - width;

        while ( prefixEnd != line.cend() )
        {
            prefixBegin = max_element( prefixBegin, ++prefixEnd );
            word += *prefixBegin++;
        }

        Joltage result = 0;
        std::from_chars( word.data(), word.data() + word.length(), result );
        return result;
    }
}

int main()
{
    Joltage part1 = 0;
    std::string line;

    while ( std::getline( std::cin, line ) )
    {
        part1 += _processLine( line, 2 );
    }

    std::cout << "part 1: " << part1 << std::endl;
    return EXIT_SUCCESS;
}
