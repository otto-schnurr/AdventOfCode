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
    int zeroCount = 0;

    for ( std::string line; std::getline( std::cin, line ); )
    {
        const int amount = _parseNumber( line );

        if ( line.front() == 'R' )
        {
            dial += amount;
        }
        else
        {
            dial -= amount;
        }

        dial %= _dialSize;
        zeroCount += dial == 0 ? 1 : 0;
    }

    std::cout << "part 1: " << zeroCount << std::endl;
    return EXIT_SUCCESS;
}
