#include <iostream>

int main()
{
    for ( std::string line; std::getline( std::cin, line ); )
    {
        std::cout << line << std::endl;
    }

    return EXIT_SUCCESS;
}
