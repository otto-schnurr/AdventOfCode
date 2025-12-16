CXX      := clang++
CXXFLAGS := -std=c++20 -Wall -Wextra -Wpedantic -Werror -O2

# Discover all dayXX.cpp files and map them to executable dayXX binaries.
SOURCE_FILES := $(wildcard day*.cpp)
EXECUTABLES  := $(SOURCE_FILES:.cpp=)

.PHONY: all clean
all: $(EXECUTABLES)

# Build rule: target "dayXX" comes from "dayXX.cpp"
%: %.cpp
	$(CXX) $(CXXFLAGS) "$<" -o "$@"

clean:
	rm -f $(EXECUTABLES)
