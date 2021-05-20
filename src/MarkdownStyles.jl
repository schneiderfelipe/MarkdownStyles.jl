module MarkdownStyles

using Markdown

export Style

# Callable structure that describes the style
struct Style{T}
    Style(name) = new{name}()
end
(s::Style)(m::Markdown.MD) = Styled(m, s)

# A decorated markdown (not meant to be used directly)
struct Styled{T,S}
    content::T
    Styled(m) = m
    Styled(m, s) = new{typeof(m),typeof(s)}(m)
end

# Default is to behave like Markdown by default
Base.show(io::IO, m::MIME"text/plain", x::Styled) = show(io, m, x.content)
Base.show(io::IO, m::MIME, x::Styled) = show(io, m, x.content)
function Base.show(io::IO, ::MIME"text/html", md::Styled{Markdown.MD,Style})
    withtag(io, :div, :class => "markdown") do
        html(io, md)
    end
end

include("html.jl")

end
