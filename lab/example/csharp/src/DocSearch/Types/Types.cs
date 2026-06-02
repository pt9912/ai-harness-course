// Domain-Modell, Pure. ADR-0001 Layer 1.
namespace DocSearch.Types;

public static class Constants
{
    public const int EmbeddingDim = 1024;
    public const int MaxTopK = 100;
}

public sealed record IndexEntry(
    string DocPath,
    string SectionTitle,
    int SectionIndex,
    string SectionText,
    float[] Embedding);

public sealed record SearchResult(string Doc, string Section, float Score);

public sealed record SearchRequest(string Q, int K);
