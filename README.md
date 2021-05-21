# MarkdownStyles.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://schneiderfelipe.github.io/MarkdownStyles.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://schneiderfelipe.github.io/MarkdownStyles.jl/dev)
[![Build Status](https://github.com/schneiderfelipe/MarkdownStyles.jl/workflows/CI/badge.svg)](https://github.com/schneiderfelipe/MarkdownStyles.jl/actions)
[![Coverage](https://codecov.io/gh/schneiderfelipe/MarkdownStyles.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/schneiderfelipe/MarkdownStyles.jl)

Write your own styles for Markdown.jl.

```julia
julia> using Markdown

julia> using MarkdownStyles

julia> m = md"""
       # MarkdownStyles.jl

       !!! info
           Styles can override specific elements! 🎉
       """;

julia> sprint(show, "text/html", NoStyle(m))  # Default Markdown.jl behavior
"<div class=\"markdown\"><h1>MarkdownStyles.jl</h1>\n<div class=\"admonition info\"><p class=\"admonition-title\">Info</p><p>Styles can override specific elements&#33; 🎉</p>\n</div>\n</div>"

julia> sprint(show, "text/html", Bulma(m))  # Uses https://bulma.io/documentation/components/message/
"<div class=\"content\"><h1>MarkdownStyles.jl</h1>\n<article class=\"message is-info\"><div class=\"message-header\"><p>Info</p></div><div class=\"message-body\"><p>Styles can override specific elements&#33; 🎉</p>\n</div></article>\n</div>"
```
