#include <iostream>
#include <charconv>
#include <regex>

using ID = long;
using Range = std::pair<long, long>;

namespace
{
    ID _parseID( std::string word )
    {
        ID result = 0;
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

        return Range( _parseID( *iWord++ ), _parseID( *iWord ) );
    }

    bool _isInvalid( ID id )
    {
        bool result = false;
        const int digitCount = static_cast<ID>( log10( id ) ) + 1L;
        const bool evenNumberOfDigits = digitCount % 2 == 0;

        if ( evenNumberOfDigits )
        {
            const int halfLength = digitCount / 2;
            const int divisor = static_cast<ID>( pow( 10, halfLength ) );

            const ID firstHalf = id / divisor;
            const ID secondHalf = id % divisor;
            result = firstHalf == secondHalf;
        }

        return result;
    }

    ID _invalidSum( Range range )
    {
        ID result = 0;

        for ( auto id = range.first; id <= range.second; ++id )
        {
            result += _isInvalid( id ) ? id : 0;
        }

        return result;
    }
}

int main()
{
    long part1 = 0;
    std::string line;

    while ( std::getline( std::cin, line, ',' ) )
    {
        part1 += _invalidSum( _parseRange( line ) );
    }

    std::cout << "part 1: " << part1 << std::endl;
    return EXIT_SUCCESS;
}
