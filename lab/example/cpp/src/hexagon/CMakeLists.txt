# Kern (Types → Index → Service + Ports). Hängt an KEINER externen
# Bibliothek und an keinem Adapter — durchgesetzt von cmake/arch-check.sh.
add_library(docsearch_hexagon
    index/index.cpp
    service/searcher.cpp
)
target_include_directories(docsearch_hexagon PUBLIC ${CMAKE_SOURCE_DIR}/src)
docsearch_set_warnings(docsearch_hexagon)
