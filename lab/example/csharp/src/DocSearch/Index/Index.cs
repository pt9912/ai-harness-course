// Index — Vektor-Storage, Cosinus, Tie-Break (slice-009, AGENTS.md §C-4).
using DocSearch.Types;

namespace DocSearch.Index;

public sealed class VectorIndex
{
    private readonly List<IndexEntry> _entries = [];

    public void Add(IndexEntry e) => _entries.Add(e);

    public int Size => _entries.Count;

    public IReadOnlyList<SearchResult> TopK(float[] query, int k)
    {
        if (k <= 0 || _entries.Count == 0)
        {
            return [];
        }
        int effectiveK = Math.Min(k, Constants.MaxTopK);

        // LINQ OrderBy ist stable. Tie-Break explizit:
        // Score absteigend, dann DocPath, dann SectionIndex.
        var scored = _entries
            .Select(e => (Entry: e, Score: Cosine(query, e.Embedding)))
            .OrderByDescending(x => x.Score)
            .ThenBy(x => x.Entry.DocPath, StringComparer.Ordinal)
            .ThenBy(x => x.Entry.SectionIndex)
            .Take(effectiveK)
            .Select(x => new SearchResult(x.Entry.DocPath, x.Entry.SectionTitle, x.Score))
            .ToList();

        return scored;
    }

    private static float Cosine(float[] a, float[] b)
    {
        double dot = 0;
        double na = 0;
        double nb = 0;
        for (int i = 0; i < a.Length; i++)
        {
            dot += a[i] * b[i];
            na += a[i] * a[i];
            nb += b[i] * b[i];
        }
        if (na == 0 || nb == 0)
        {
            return 0;
        }
        return (float)(dot / (Math.Sqrt(na) * Math.Sqrt(nb)));
    }
}
