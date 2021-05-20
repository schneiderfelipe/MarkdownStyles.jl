module MarkdownStyles

using Markdown

export Style, NoStyle, Bulma

# Callable structure that describes the style
struct Style{T}
    Style(name) = new{name}()
end
Style{T}(x) where T = Styled(x, Style(T))
(s::Style)(x) = Styled(x, s)

# A decorated markdown (not meant to be used directly)
struct Styled{T,S}
    content::T
    style::S
    Styled(m) = m
    Styled(m, s) = new{typeof(m),typeof(s)}(m, s)
end
content(x::Styled) = getfield(x, :content)
style(x::Styled) = getfield(x, :style)
Base.getproperty(x::Styled, prop::Symbol) = getproperty(content(x), prop)

# Default is to behave like Markdown.jl
Base.show(io::IO, m::MIME"text/plain", x::Styled) = show(io, m, content(x))
Base.show(io::IO, m::MIME, x::Styled) = show(io, m, content(x))
function Base.show(io::IO, ::MIME"text/html", md::Styled{Markdown.MD})
    Markdown.withtag(io, :div, :class => class(style(md))) do
        html(io, md)
    end
end

include("html.jl")
include("styles/bulma.jl")

end
