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
}

int main()
{
    for ( std::string line; std::getline( std::cin, line ); )
    {
        const int number = _parseNumber( line );
        std::cout << number << std::endl;
    }

    return EXIT_SUCCESS;
}
