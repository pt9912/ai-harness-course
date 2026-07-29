// DocSearch Entry-Point. Wiring gemäß ADR-0001.
using DocSearch.Embedding;
using DocSearch.Index;
using DocSearch.Service;

const string version = "0.3.0";

if (args.Contains("--version"))
{
    Console.WriteLine(version);
    return 0;
}
if (args.Length == 0 || args.Contains("--help"))
{
    Console.Error.WriteLine($"DocSearch {version}\n\nNutzung: DocSearch [--version]");
    return 0;
}

VectorIndex idx = new();
MockEmbedder emb = new();
_ = new Searcher(idx, emb);
Console.WriteLine("DocSearch wired. HTTP-Start bleibt ausserhalb des Lab-Skeletts (Lab-Grenze).");
return 0;
