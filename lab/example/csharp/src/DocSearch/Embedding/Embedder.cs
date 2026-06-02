// Embedder-Port (ADR-0002). Importiert nur Types.
using System.Security.Cryptography;
using System.Text;
using DocSearch.Types;

namespace DocSearch.Embedding;

public interface IEmbedder
{
    float[] Embed(string text);
}

public sealed class MockEmbedder : IEmbedder
{
    public float[] Embed(string text)
    {
        byte[] digest = SHA256.HashData(Encoding.UTF8.GetBytes(text));
        long seed = 0L;
        for (int i = 0; i < 8; i++)
        {
            seed = (seed << 8) | digest[i];
        }
        float[] result = new float[Constants.EmbeddingDim];
        for (int i = 0; i < Constants.EmbeddingDim; i++)
        {
            seed = seed * 1103515245L + 12345L;
            result[i] = (float)(((seed >> 16) & 0x7FFFL) / 32768.0);
        }
        return result;
    }
}
