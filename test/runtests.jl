using Markdown
using MarkdownStyles
using Test

macro renders(x, s)
    esc(quote
        @test sprint(show, "text/html", $x) == $s
    end)
end

macro rendersas(x, y)
    esc(quote
        @renders $x sprint(show, "text/html", $y)
    end)
end

@testset "MarkdownStyles.jl" begin
    # Types and singletons
    @test Style(:example) isa Style{:example}
    @test Style(:example) === Style(:example)
    @test Style(:example)(md"Hello") isa MarkdownStyles.Styled

    blocks = (
        md"# title",
        md"## title",
        md"""
        ```julia
        println("code")
        ```
        """,
        md"paragraph",
        md"> blockquote",
        md"""
        text [^1]

        [^1]: footnote
        """,
        md"""
        !!! info
            admonition
        """,
        md"""- list""",
        md"""---""",
    )

    inlines = (
        md"`code`",
        md"**bold**",
        md"*italic*",
        md"![image](https://picsum.photos/200/200)",
        md"[link](https://julialang.com)",
    )

    # New styles behave the same as Markdown.jl by default
    @testset "Block elements" for x in blocks
        @rendersas Style(:noop)(x) x
    end
    @testset "Inline elements" for x in inlines
        @rendersas Style(:noop)(x) x
    end
end
