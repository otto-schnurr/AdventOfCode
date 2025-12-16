#include <iostream>
#include <charconv>

namespace
{
    int _parseNumber( std::string line )
    {
        if ( line.front() == 'L' )
        {
            // Replace the L.
            line.front() = '-';
        }
        else
        {
            // Remove the R.
            line.erase( line.begin(), line.begin() + 1 );
        }

        int result = 0;
        std::from_chars( line.data(), line.data() + line.size(), result );
        return result;
    }

    int _rotateDial( int dial, int amount )
    {
        const int dialSize = 100;

        dial += amount % dialSize;
        dial %= dialSize;
        dial += dial < 0 ? dialSize : 0;
        
        return dial;
    }
}

int main()
{
    int dial = 50;
    int zeroCount = 0;

    for ( std::string line; std::getline( std::cin, line ); )
    {
        const int amount = _parseNumber( line );
        dial = _rotateDial( dial, amount );
        zeroCount += dial == 0 ? 1 : 0;
    }

    std::cout << "part 1: " << zeroCount << std::endl;
    return EXIT_SUCCESS;
}
