# Adapter (Embedding, UI). Hängen am Kern (über die Ports), nie der Kern
# an ihnen. Ein Adapter importiert keinen anderen Adapter (arch-check).
add_library(docsearch_adapters
    embedding/mock_embedder.cpp
    ui/search_handler.cpp
)
target_include_directories(docsearch_adapters PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(docsearch_adapters PUBLIC docsearch_hexagon)
docsearch_set_warnings(docsearch_adapters)
