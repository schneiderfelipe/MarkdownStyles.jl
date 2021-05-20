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
macro rendersas(x, y, class)
    esc(quote
        @renders $x replace(sprint(show, "text/html", $y), "<div class=\"markdown\">" => "<div class=\"$($(class))\">")
    end)
end

@testset "MarkdownStyles.jl" begin
    # Types and singletons
    @test Style(:example) isa Style{:example}
    @test Style(:example) === Style(:example)
    @test Style(:example)(md"Hello") isa MarkdownStyles.Styled

    blocks = (
        header=md"# header",
        code=md"""
        ```julia
        println("code")
        ```
        """,
        paragraph=md"paragraph",
        blockquote=md"> blockquote",
        footnote=md"""
        text [^1]

        [^1]: footnote
        """,
        admonition=md"""
        !!! info
            admonition
        """,
        list=md"""- list""",
        ruler=md"""---""",
    )

    inlines = (
        code=md"`code`",
        bold=md"**bold**",
        italic=md"*italic*",
        image=md"![image](https://picsum.photos/200/200)",
        link=md"[link](https://julialang.com)",
    )

    # New styles behave the same as Markdown.jl by default
    @testset "NoStyle" begin
        @testset "Block elements" for x ∈ blocks
            @rendersas NoStyle(x) x
        end
        @testset "Inline elements" for x ∈ inlines
            @rendersas NoStyle(x) x
        end
    end

    @testset "Bulma" begin
        @testset "Block elements" for (k, x) ∈ pairs(blocks)
            if k ∉ (:admonition,)
                @rendersas Bulma(x) x "content"
            end
        end
        @testset "Inline elements" for (k, x) ∈ pairs(inlines)
            if k ∉ (:image,)
                @rendersas Bulma(x) x "content"
            end
        end

        @renders Bulma(blocks.admonition) """<div class="content"><article class="message is-info"><div class="message-header"><p>Info</p></div><div class="message-body"><p>admonition</p>\n</div></article>\n</div>"""
        @renders Bulma(inlines.image) """<div class="content"><p><figure class="image"><img src="https://picsum.photos/200/200" alt="image" /></figure></p>\n</div>"""
    end
end
