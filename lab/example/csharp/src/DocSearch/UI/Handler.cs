// UI-Layer. ADR-0001: importiert Service + Types; KEIN Index, Embedding direkt.
using DocSearch.Service;
using DocSearch.Types;

namespace DocSearch.UI
{
    /// <summary>Antwort des UI-Layers: Status und Körper, ohne echten HTTP-Server.</summary>
    public sealed record HttpResult(int Status, IReadOnlyDictionary<string, object> Body);

    /// <summary>Status und Fehler-Code eines abgebildeten Fehlers.</summary>
    public sealed record ErrorMapping(int Status, string Code);

    public sealed class Handler(Searcher searcher, Indexer? indexer = null)
    {
        /// <summary>
        /// Bildet die Fehler-Codes aus spec/spezifikation.md §4 auf HTTP-Status
        /// ab. Unbekannte Fehler sind E099.
        /// </summary>
        public static ErrorMapping StatusFor(Exception exc)
        {
            return exc switch
            {
                DirectoryMissingException => new ErrorMapping(400, "E001"),
                EmptyQueryException => new ErrorMapping(400, "E002"),
                EmbeddingUnavailableException => new ErrorMapping(503, "E003"),
                _ => new ErrorMapping(500, "E099"),
            };
        }

        public SearchResponse HandleSearch(SearchRequest req)
        {
            return searcher.Search(req);
        }

        /// <summary>Suche mit Fehler-Abbildung nach spec/spezifikation.md §4.</summary>
        public HttpResult HandleSearchHttp(SearchRequest req)
        {
            try
            {
                SearchResponse resp = searcher.Search(req);
                return new HttpResult(
                    200, new Dictionary<string, object> { ["results"] = resp.Results });
            }
            catch (Exception e)
            {
                return Failure(e);
            }
        }

        /// <summary>Reindex (LH-FA-01) mit Fehler-Abbildung nach spec §4.</summary>
        public HttpResult HandleReindex(string directory)
        {
            if (indexer is null)
            {
                return new HttpResult(
                    500, new Dictionary<string, object> { ["error"] = "E099" });
            }
            try
            {
                int n = indexer.Reindex(directory);
                return new HttpResult(
                    200, new Dictionary<string, object> { ["indexed_docs"] = n });
            }
            catch (Exception e)
            {
                return Failure(e);
            }
        }

        private static HttpResult Failure(Exception exc)
        {
            ErrorMapping m = StatusFor(exc);
            return new HttpResult(
                m.Status, new Dictionary<string, object> { ["error"] = m.Code });
        }
    }
}
