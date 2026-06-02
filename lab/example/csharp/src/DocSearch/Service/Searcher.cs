// Service (LH-FA-02). ADR-0001: darf Types, Index, Embedding; KEIN UI.
using DocSearch.Embedding;
using DocSearch.Index;
using DocSearch.Types;

namespace DocSearch.Service;

public sealed class EmptyQueryException()
    : InvalidOperationException("E002: empty query");

public sealed class EmbeddingUnavailableException(Exception inner)
    : InvalidOperationException("E003: embedding unavailable", inner);

public sealed record SearchResponse(IReadOnlyList<SearchResult> Results, bool KClamped);

public sealed class Searcher(VectorIndex index, IEmbedder embedder)
{
    public SearchResponse Search(SearchRequest req)
    {
        if (string.IsNullOrEmpty(req.Q))
        {
            throw new EmptyQueryException();
        }
        int k = req.K;
        bool clamped = false;
        if (k > Constants.MaxTopK)
        {
            k = Constants.MaxTopK;
            clamped = true;
        }
        float[] vec;
        try
        {
            vec = embedder.Embed(req.Q);
        }
        catch (Exception e)
        {
            throw new EmbeddingUnavailableException(e);
        }
        return new SearchResponse(index.TopK(vec, k), clamped);
    }
}
