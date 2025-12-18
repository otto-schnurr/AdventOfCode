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

    bool _isInvalid( ID id, int factor, int digitCount )
    {
        if ( digitCount % factor == 0 )
        {
            const auto stride = digitCount / factor;
            const auto divisor = static_cast<ID>( pow( 10, stride ) );
            ID firstSegment = 0;

            for ( auto count = 1; count <= factor; ++count )
            {
                const ID nextSegment = id % divisor;
                id /= divisor;

                if ( count == 1 )
                {
                    firstSegment = nextSegment;
                }
                else if ( nextSegment != firstSegment )
                {
                    return false;
                }
            }

            return true;
        }

        return false;
    }

    ID _invalidSum( Range range )
    {
        ID result = 0;

        for ( auto id = range.first; id <= range.second; ++id )
        {
            const int digitCount = static_cast<ID>( log10( id ) ) + 1L;
            result += _isInvalid( id, 2, digitCount ) ? id : 0;
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
