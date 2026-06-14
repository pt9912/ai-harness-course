cmake_minimum_required(VERSION 3.24)

project(docsearch_cpp VERSION 0.3.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)  # für clang-tidy (make lint)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "" FORCE)
endif()

# Typecheck-Gate: Warnungen sind Fehler. Gilt nur für unseren Code (nicht
# für FetchContent-Dependencies wie doctest, das als SYSTEM-Target kommt).
function(docsearch_set_warnings target)
    target_compile_options(${target} PRIVATE -Wall -Wextra -Werror)
endfunction()

include(CTest)  # aktiviert enable_testing()

# Coverage-Instrumentierung (make coverage-gate). Aus, damit Release-Builds
# und der Determinismus-Lauf nicht instrumentiert sind.
option(DOCSEARCH_COVERAGE "Mit gcov-Coverage-Instrumentierung bauen" OFF)
if(DOCSEARCH_COVERAGE)
    add_compile_options(--coverage -O0 -g)
    add_link_options(--coverage)
endif()

include(cmake/Dependencies.cmake)

add_subdirectory(src)
add_subdirectory(tests)

# arch-check als CTest-Test (ADR-0001) — rein textbasiert, keine Toolchain
# nötig. Erlaubt `ctest -R arch-check` neben `make arch-check`.
add_test(
    NAME arch-check
    COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/cmake/arch-check.sh
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
