using DocSearch.Embedding;
using DocSearch.Index;
using DocSearch.Service;
using DocSearch.Types;
using DocSearch.UI;
using Xunit;

namespace DocSearch.Tests
{
    // Port-Double DownEmbedder (E003-Pfad) liegt in SearchTests.cs — dieselbe
    // Namespace, kein zweites Double.

    /// <summary>LH-FA-01 Reindex + Fehler-Abbildung E001/E002/E003/E099 (spec §4).</summary>
    public class ReindexTests : IDisposable
    {
        private readonly string _dir = Path.Combine(
            Path.GetTempPath(), "docsearch-reindex-" + Guid.NewGuid().ToString("N"));

        public ReindexTests()
        {
            _ = Directory.CreateDirectory(_dir);
        }

        public void Dispose()
        {
            if (Directory.Exists(_dir))
            {
                Directory.Delete(_dir, recursive: true);
            }
            GC.SuppressFinalize(this);
        }

        private static Handler MakeHandler(IEmbedder emb)
        {
            VectorIndex idx = new();
            return new Handler(new Searcher(idx, emb), new Indexer(idx, emb));
        }

        private void Write(string name)
        {
            File.WriteAllText(Path.Combine(_dir, name), "# " + name);
        }

        [Fact]
        public void Reindex_HappyPath_LHFA01()
        {
            Write("a.md");
            Write("b.md");
            HttpResult res = MakeHandler(new MockEmbedder()).HandleReindex(_dir);
            Assert.Equal(200, res.Status);
            Assert.Equal(2, res.Body["indexed_docs"]);
        }

        [Fact]
        public void Reindex_Boundary_EmptyDirIsNoError_LHFA01()
        {
            HttpResult res = MakeHandler(new MockEmbedder()).HandleReindex(_dir);
            Assert.Equal(200, res.Status);
            Assert.Equal(0, res.Body["indexed_docs"]);
        }

        [Fact]
        public void Reindex_Negative_MissingDirYieldsE001_LHFA01()
        {
            HttpResult res = MakeHandler(new MockEmbedder())
                .HandleReindex(Path.Combine(_dir, "weg"));
            Assert.Equal(400, res.Status);
            Assert.Equal("E001", res.Body["error"]);
        }

        [Fact]
        public void Reindex_IsDeterministic_LHQA02()
        {
            Write("b.md");
            Write("a.md");
            MockEmbedder emb = new();
            VectorIndex first = new();
            Assert.Equal(2, new Indexer(first, emb).Reindex(_dir));
            VectorIndex second = new();
            Assert.Equal(2, new Indexer(second, emb).Reindex(_dir));
            Assert.Equal(first.Size, second.Size);
            IReadOnlyList<SearchResult> a =
                new Searcher(first, emb).Search(new SearchRequest("frage", 2)).Results;
            IReadOnlyList<SearchResult> b =
                new Searcher(second, emb).Search(new SearchRequest("frage", 2)).Results;
            Assert.Equal(a, b);
        }

        [Fact]
        public void Reindex_EmbeddingDownYieldsE003()
        {
            Write("a.md");
            HttpResult res = MakeHandler(new DownEmbedder()).HandleReindex(_dir);
            Assert.Equal(503, res.Status);
            Assert.Equal("E003", res.Body["error"]);
        }

        [Fact]
        public void Indexer_ThrowsE001_Directly()
        {
            Indexer ix = new(new VectorIndex(), new MockEmbedder());
            string missing = Path.Combine(_dir, "weg");
            DirectoryMissingException ex =
                Assert.Throws<DirectoryMissingException>(
                    () => ix.Reindex(missing));
            Assert.Contains("E001", ex.Message, StringComparison.Ordinal);
        }

        [Fact]
        public void StatusFor_UnknownError_IsE099()
        {
            ErrorMapping m = Handler.StatusFor(new InvalidOperationException("unerwartet"));
            Assert.Equal(500, m.Status);
            Assert.Equal("E099", m.Code);
        }

        [Fact]
        public void StatusFor_AlleCodes_SpecParagraph4()
        {
            Assert.Equal(
                "E001", Handler.StatusFor(new DirectoryMissingException()).Code);
            Assert.Equal("E002", Handler.StatusFor(new EmptyQueryException()).Code);
            Assert.Equal(
                503,
                Handler.StatusFor(
                    new EmbeddingUnavailableException(new InvalidOperationException())).Status);
        }

        [Fact]
        public void Handler_OhneIndexer_LiefertE099()
        {
            Handler h = new(new Searcher(new VectorIndex(), new MockEmbedder()));
            HttpResult res = h.HandleReindex("/beliebig");
            Assert.Equal(500, res.Status);
            Assert.Equal("E099", res.Body["error"]);
        }
    }
}
