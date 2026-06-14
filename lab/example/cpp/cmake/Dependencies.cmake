# Test-Framework als gepinnte Dependency (doctest, header-only).
# FetchContent + GIT_TAG ist die "Lockfile"-Story dieses Skeletts — analog
# zu go.sum / uv.lock / packages.lock.json in den anderen Sprachen.
include(FetchContent)

set(FETCHCONTENT_UPDATES_DISCONNECTED ON)

set(DOCTEST_WITH_TESTS OFF CACHE INTERNAL "")
set(DOCTEST_WITH_MAIN_IN_STATIC_LIB OFF CACHE INTERNAL "")
set(DOCTEST_NO_INSTALL ON CACHE INTERNAL "")
FetchContent_Declare(
    doctest
    GIT_REPOSITORY https://github.com/doctest/doctest.git
    GIT_TAG v2.4.11
)

FetchContent_MakeAvailable(doctest)
