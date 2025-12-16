#include <iostream>
using std::replace;

namespace
{
    std::optional<int> _parseNumber( std::string line )
    {
        // implement me
        (void)line;
        return 42;
    }
}

int main()
{
    for ( std::string line; std::getline( std::cin, line ); )
    {
        replace( line.begin(), line.end(), 'L', '-' );
        replace( line.begin(), line.end(), 'R', '+' );

        if ( auto number = _parseNumber( line ) )
        {
            std::cout << *number << std::endl;
        }
    }

    return EXIT_SUCCESS;
}
