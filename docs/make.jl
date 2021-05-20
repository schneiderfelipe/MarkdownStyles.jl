using MarkdownStyles
using Documenter

DocMeta.setdocmeta!(MarkdownStyles, :DocTestSetup, :(using MarkdownStyles); recursive=true)

makedocs(;
    modules=[MarkdownStyles],
    authors="Felipe S. S. Schneider <schneider.felipe@posgrad.ufsc.br> and contributors",
    repo="https://github.com/schneiderfelipe/MarkdownStyles.jl/blob/{commit}{path}#{line}",
    sitename="MarkdownStyles.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://schneiderfelipe.github.io/MarkdownStyles.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/schneiderfelipe/MarkdownStyles.jl",
)
