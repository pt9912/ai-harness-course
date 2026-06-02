// UI-Layer. ADR-0001: importiert Service + Types; KEIN Index, Embedding direkt.
using DocSearch.Service;
using DocSearch.Types;

namespace DocSearch.UI;

public sealed class Handler(Searcher searcher)
{
    public SearchResponse HandleSearch(SearchRequest req) => searcher.Search(req);
}
