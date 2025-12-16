CXX      := clang++
CXXFLAGS := -std=c++20 -Wall -Wextra -Wpedantic -Werror -O2

# Discover all dayXX.cpp files and map them to executable dayXX binaries.
SOURCE_FILES := $(wildcard day*.cpp)
EXECUTABLES  := $(SOURCE_FILES:.cpp=)

.PHONY: all clean
all: $(EXECUTABLES)

# Build rule: target "dayXX" comes from "dayXX.cpp"
%: %.cpp
	@if command -v clang-tidy >/dev/null 2>&1; then \
		echo "clang-tidy $<"; \
		clang-tidy "$<" -- $(CXXFLAGS); \
	else \
		echo "clang-tidy not found; skipping"; \
	fi
	$(CXX) $(CXXFLAGS) "$<" -o "$@"

clean:
	rm -f $(EXECUTABLES)
