using DocSearch.Embedding;
using DocSearch.Index;
using DocSearch.Service;
using DocSearch.Types;
using Xunit;

namespace DocSearch.Tests;

public class SearchTests
{
    private static Searcher Setup(int n)
    {
        VectorIndex idx = new();
        MockEmbedder emb = new();
        for (int i = 0; i < n; i++)
        {
            float[] vec = emb.Embed($"seed-{(char)('a' + (i % 26))}");
            idx.Add(new IndexEntry(
                DocPath: $"doc-{(char)('a' + (i % 26))}.md",
                SectionTitle: "Section",
                SectionIndex: i,
                SectionText: "…",
                Embedding: vec));
        }
        return new Searcher(idx, emb);
    }

    [Fact]
    public void Search_HappyPath_LHFA02()
    {
        var s = Setup(5);
        var resp = s.Search(new SearchRequest("frage", 3));
        Assert.Equal(3, resp.Results.Count);
        Assert.False(resp.KClamped);
    }

    [Fact]
    public void Search_Boundary_KClamped_LHFA02()
    {
        var s = Setup(200);
        var resp = s.Search(new SearchRequest("frage", 500));
        Assert.True(resp.KClamped);
        Assert.Equal(Constants.MaxTopK, resp.Results.Count);
    }

    [Fact]
    public void Search_Negative_EmptyQuery_LHFA02()
    {
        var s = Setup(5);
        Assert.Throws<EmptyQueryException>(() => s.Search(new SearchRequest("", 5)));
    }

    [Fact]
    public void TieBreak_slice009()
    {
        VectorIndex idx = new();
        MockEmbedder emb = new();
        float[] vec = emb.Embed("seed");
        idx.Add(new IndexEntry("b.md", "B", 0, "…", vec));
        idx.Add(new IndexEntry("a.md", "A1", 1, "…", vec));
        idx.Add(new IndexEntry("a.md", "A0", 0, "…", vec));

        var s = new Searcher(idx, emb);
        var resp = s.Search(new SearchRequest("seed", 3));

        Assert.Equal("a.md", resp.Results[0].Doc);
        Assert.Equal("A0", resp.Results[0].Section);
        Assert.Equal("a.md", resp.Results[1].Doc);
        Assert.Equal("A1", resp.Results[1].Section);
        Assert.Equal("b.md", resp.Results[2].Doc);
    }
}
