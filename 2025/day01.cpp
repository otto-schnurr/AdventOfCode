#include <iostream>
using std::replace;

int main()
{
    for ( std::string line; std::getline( std::cin, line ); )
    {
        replace( line.begin(), line.end(), 'L', '-' );
        replace( line.begin(), line.end(), 'R', '+' );
        std::cout << line << std::endl;
    }

    return EXIT_SUCCESS;
}
