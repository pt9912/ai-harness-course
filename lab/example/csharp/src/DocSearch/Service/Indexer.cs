// Service (LH-FA-01). ADR-0001: darf Types, Index, Embedding; KEIN UI.
using DocSearch.Embedding;
using DocSearch.Index;
using DocSearch.Types;

namespace DocSearch.Service
{
    /// <summary>
    /// E001 — Verzeichnis existiert nicht (spec/spezifikation.md §4).
    /// Heißt bewusst nicht <c>DirectoryNotFoundException</c>: der Name
    /// gehört in C# zu <see cref="System.IO"/> und würde den BCL-Typ
    /// verdecken. Der Fehler-Code E001 ist sprachübergreifend derselbe.
    /// </summary>
    public sealed class DirectoryMissingException()
        : InvalidOperationException("E001: directory not found");

    public sealed class Indexer(VectorIndex index, IEmbedder embedder)
    {
        /// <summary>
        /// Indexiert alle <c>.md</c>-Dateien und liefert <c>indexed_docs</c>.
        /// Fehlt das Verzeichnis, wird <see cref="DirectoryMissingException"/>
        /// (E001) geworfen. Ein leeres Verzeichnis ist kein Fehler
        /// (LH-FA-01 Boundary).
        /// </summary>
        public int Reindex(string directory)
        {
            if (!Directory.Exists(directory))
            {
                throw new DirectoryMissingException();
            }

            // Deterministische Reihenfolge: LH-QA-02 verlangt bit-identische
            // Ergebnisse bei identischer Eingabe.
            string[] names = [.. Directory.GetFiles(directory, "*.md")
                .Select(Path.GetFileName)
                .Where(n => n is not null)
                .Select(n => n!)
                .OrderBy(n => n, StringComparer.Ordinal)];

            for (int i = 0; i < names.Length; i++)
            {
                string text = File.ReadAllText(Path.Combine(directory, names[i]));
                float[] vec;
                try
                {
                    vec = embedder.Embed(text);
                }
                catch (Exception e)
                {
                    throw new EmbeddingUnavailableException(e);
                }
                index.Add(new IndexEntry(
                    names[i], FirstHeading(text, names[i]), i, text, vec));
            }
            return names.Length;
        }

        private static string FirstHeading(string text, string fallback)
        {
            foreach (string line in text.Split('\n'))
            {
                if (line.StartsWith('#'))
                {
                    return line.TrimStart('#', ' ').Trim();
                }
            }
            return fallback;
        }
    }
}
