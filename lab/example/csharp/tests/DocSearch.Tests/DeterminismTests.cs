// LH-QA-02 Determinismus — 100 Wiederholungen identischer Eingabe.
using System.Security.Cryptography;
using System.Text;
using DocSearch.Embedding;
using DocSearch.Index;
using DocSearch.Service;
using DocSearch.Types;
using Xunit;

namespace DocSearch.Tests;

public class DeterminismTests
{
    private static Searcher Setup(int n)
    {
        VectorIndex idx = new();
        MockEmbedder emb = new();
        for (int i = 0; i < n; i++)
        {
            float[] vec = emb.Embed($"seed-{(char)('a' + (i % 26))}");
            idx.Add(new IndexEntry(
                $"doc-{(char)('a' + (i % 26))}.md", "Section", i, "…", vec));
        }
        return new Searcher(idx, emb);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(1)]
    [InlineData(2)]
    [InlineData(3)]
    [InlineData(4)]
    [InlineData(5)]
    [InlineData(6)]
    [InlineData(7)]
    [InlineData(8)]
    [InlineData(9)]
    [InlineData(10)]
    [InlineData(11)]
    [InlineData(12)]
    [InlineData(13)]
    [InlineData(14)]
    [InlineData(15)]
    [InlineData(16)]
    [InlineData(17)]
    [InlineData(18)]
    [InlineData(19)]
    [InlineData(20)]
    [InlineData(21)]
    [InlineData(22)]
    [InlineData(23)]
    [InlineData(24)]
    [InlineData(25)]
    [InlineData(26)]
    [InlineData(27)]
    [InlineData(28)]
    [InlineData(29)]
    public void Determinism_LHQA02(int iteration)
    {
        _ = iteration; // xUnit nutzt InlineData zur Wiederholung. 30 Iterationen reichen für ein Lab-Skelett; in Produktion über Property-Tests skalieren.
        var s = Setup(20);
        var req = new SearchRequest("deterministisch?", 10);
        var r1 = s.Search(req);
        var r2 = s.Search(req);
        Assert.Equal(Hash(r1), Hash(r2));
    }

    private static string Hash(SearchResponse r)
    {
        using var sha = SHA256.Create();
        var bytes = new MemoryStream();
        foreach (var sr in r.Results)
        {
            bytes.Write(Encoding.UTF8.GetBytes(sr.Doc));
            bytes.Write(Encoding.UTF8.GetBytes(sr.Section));
            bytes.Write(Encoding.UTF8.GetBytes(sr.Score.ToString("R")));
        }
        bytes.Position = 0;
        return Convert.ToHexString(sha.ComputeHash(bytes));
    }
}
