#include <charconv>
#include <iostream>
#include <regex>

using Range = std::pair<int, int>;

namespace
{
    int _parseNumber( std::string word )
    {
        int result = 0;
        std::from_chars( word.data(), word.data() + word.length(), result );
        return result;
    }

    Range _parseRange( const std::string& line )
    {
        const std::regex delimiter( "-" );
        const int unmatched = -1;
        auto iWord = std::sregex_token_iterator(
            line.begin(), line.end(), delimiter, unmatched
        );

        return Range( _parseNumber( *iWord++ ), _parseNumber( *iWord ) );
    }
}

int main()
{
    for ( std::string line; std::getline( std::cin, line, ',' ); )
    {
        const Range range = _parseRange( line );
        std::cout << "from " << range.first;
        std::cout << " to " << range.second << std::endl;
    }

    return EXIT_SUCCESS;
}
