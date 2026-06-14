add_subdirectory(hexagon)
add_subdirectory(adapters)

# Composition Root — verdrahtet Kern + Adapter (ADR-0001).
add_executable(docsearch main.cpp)
target_include_directories(docsearch PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(docsearch PRIVATE docsearch_hexagon docsearch_adapters)
# Runtime-Binary self-contained ggü. libstdc++/libgcc — so genügt das
# Distroless cc-Image (glibc), unabhängig davon, ob es libstdc++ mitbringt.
target_link_options(docsearch PRIVATE -static-libstdc++ -static-libgcc)
docsearch_set_warnings(docsearch)
