add_executable(docsearch_tests search_test.cpp)
target_include_directories(docsearch_tests PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(docsearch_tests PRIVATE docsearch_hexagon docsearch_adapters doctest::doctest)
docsearch_set_warnings(docsearch_tests)

# Benannte CTest-Tests: `make test` fährt unit, `make test-determinism`
# fährt gezielt den Determinismus-Case (LH-QA-02).
add_test(NAME unit COMMAND docsearch_tests)
add_test(NAME determinism COMMAND docsearch_tests --test-case=*Determinism*)
