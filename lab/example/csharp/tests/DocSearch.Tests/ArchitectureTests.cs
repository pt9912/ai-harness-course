// ADR-0001 Layering — NetArchTest. AGENTS.md §C-2.
using NetArchTest.Rules;
using Xunit;

namespace DocSearch.Tests;

public class ArchitectureTests
{
    [Fact]
    public void UI_Should_Not_Depend_On_Index_Or_Embedding()
    {
        var result = Types.InAssembly(typeof(DocSearch.UI.Handler).Assembly)
            .That().ResideInNamespace("DocSearch.UI")
            .ShouldNot().HaveDependencyOnAny("DocSearch.Index", "DocSearch.Embedding")
            .GetResult();
        Assert.True(result.IsSuccessful,
            $"ADR-0001: UI hat Direkt-Abhängigkeit. Failing types: " +
            string.Join(", ", result.FailingTypeNames ?? []));
    }

    [Fact]
    public void Service_Should_Not_Depend_On_UI()
    {
        var result = Types.InAssembly(typeof(DocSearch.Service.Searcher).Assembly)
            .That().ResideInNamespace("DocSearch.Service")
            .ShouldNot().HaveDependencyOn("DocSearch.UI")
            .GetResult();
        Assert.True(result.IsSuccessful);
    }

    [Fact]
    public void Index_Should_Not_Depend_On_Service_Or_UI()
    {
        var result = Types.InAssembly(typeof(DocSearch.Index.VectorIndex).Assembly)
            .That().ResideInNamespace("DocSearch.Index")
            .ShouldNot().HaveDependencyOnAny("DocSearch.Service", "DocSearch.UI")
            .GetResult();
        Assert.True(result.IsSuccessful);
    }

    [Fact]
    public void Embedding_Should_Not_Depend_On_Service_UI_Or_Index()
    {
        var result = Types.InAssembly(typeof(DocSearch.Embedding.IEmbedder).Assembly)
            .That().ResideInNamespace("DocSearch.Embedding")
            .ShouldNot().HaveDependencyOnAny("DocSearch.Service", "DocSearch.UI", "DocSearch.Index")
            .GetResult();
        Assert.True(result.IsSuccessful);
    }
}
