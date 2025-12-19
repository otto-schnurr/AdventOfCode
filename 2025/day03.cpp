#include <iostream>
#include <algorithm>
#include <charconv>

namespace
{
    int _processLine( const std::string& line )
    {
        const auto firstDigit = max_element( line.begin(), line.end() - 1 );
        const auto secondDigit = max_element( firstDigit + 1, line.end() );
        const auto word = std::string() + *firstDigit + *secondDigit;

        int result = 0;
        std::from_chars( word.data(), word.data() + word.length(), result );
        return result;
    }
}

int main()
{
    std::string line;
    int part1 = 0;

    while ( std::getline( std::cin, line ) )
    {
        part1 += _processLine( line );
    }

    std::cout << "part 1: " << part1 << std::endl;
    return EXIT_SUCCESS;
}
