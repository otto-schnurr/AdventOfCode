#include <iostream>
#include <charconv>
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

    bool _isInvalid( int id )
    {
        bool result = false;
        const int digitCount = static_cast<int>( log10( id ) ) + 1;
        const bool evenNumberOfDigits = digitCount % 2 == 0;

        if ( evenNumberOfDigits )
        {
            const int halfLength = digitCount / 2;
            const int divisor = static_cast<int>( pow( 10, halfLength ) );

            const int firstHalf = id / divisor;
            const int secondHalf = id % divisor;
            result = firstHalf == secondHalf;
        }

        return result;
    }

    int _invalidSum( Range range )
    {
        int result = 0;

        for ( auto id = range.first; id <= range.second; ++id )
        {
            result += _isInvalid( id ) ? id : 0;
        }

        return result;
    }
}

int main()
{
    int part1 = 0;

    for ( std::string line; std::getline( std::cin, line, ',' ); )
    {
        part1 += _invalidSum( _parseRange( line ) );
    }

    std::cout << "part 1: " << part1 << std::endl;
    return EXIT_SUCCESS;
}
