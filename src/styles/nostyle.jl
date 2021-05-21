const NoStyle = Style{:nostyle}
class(::Style) = "markdown"

# Block elements

Markdown.html(io::IO, md::Styled) = html(io, content(md))

function Markdown.html(io::IO, c::Styled{<:AbstractVector})
    for md ∈ content(c)
        html(io, style(c)(md))
        println(io)
    end
end

Markdown.html(io::IO, md::Styled{Markdown.MD}) = html(io, style(md)(md.content))

function Markdown.html(io::IO, header::Styled{Markdown.Header{l}}) where l
    Markdown.withtag(io, "h$l") do
        Markdown.htmlinline(io, style(header)(header.text))
    end
end

# function Markdown.html(io::IO, code::Styled{Markdown.Code})
#     Markdown.withtag(io, :pre) do
#         maybe_lang = !isempty(code.language) ? Any[:class => "language-$(code.language)"] : []
#         Markdown.withtag(io, :code, maybe_lang...) do
#             Markdown.htmlesc(io, code.code)
#             # TODO should print newline if this is longer than one line ?
#         end
#     end
# end

function Markdown.html(io::IO, md::Styled{Markdown.Paragraph})
    Markdown.withtag(io, :p) do
        Markdown.htmlinline(io, style(md)(md.content))
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.BlockQuote})
    Markdown.withtag(io, :blockquote) do
        println(io)
        html(io, style(md)(md.content))
    end
end

function Markdown.html(io::IO, f::Styled{Markdown.Footnote})
    Markdown.withtag(io, :div, :class => "footnote", :id => "footnote-$(f.id)") do
        Markdown.withtag(io, :p, :class => "footnote-title") do
            print(io, f.id)
        end
        html(io, style(f)(f.text))
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.Admonition})
    Markdown.withtag(io, :div, :class => "admonition $(md.category)") do
        Markdown.withtag(io, :p, :class => "admonition-title") do
            print(io, md.title)
        end
        html(io, style(md)(md.content))
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.List})
    maybe_attr = md.ordered > 1 ? Any[:start => string(md.ordered)] : []
    Markdown.withtag(io, Markdown.isordered(content(md)) ? :ol : :ul, maybe_attr...) do
        for item ∈ md.items
            println(io)
            Markdown.withtag(io, :li) do
                html(io, style(md)(item))
            end
        end
        println(io)
    end
end

# function Markdown.html(io::IO, md::Styled{Markdown.HorizontalRule})
#     Markdown.tag(io, :hr)
# end

# Inline elements

Markdown.htmlinline(io::IO, md::Styled) = Markdown.htmlinline(io, content(md))

function Markdown.htmlinline(io::IO, c::Styled{<:AbstractVector})
    for x ∈ content(c)
        Markdown.htmlinline(io, style(c)(x))
    end
end

# function Markdown.htmlinline(io::IO, code::Styled{Markdown.Code})
#     Markdown.withtag(io, :code) do
#         Markdown.htmlesc(io, code.code)
#     end
# end

# function Markdown.htmlinline(io::IO, md::Styled{<:Union{Symbol,AbstractString}})
#     Markdown.htmlesc(io, content(md))
# end

function Markdown.htmlinline(io::IO, md::Styled{Markdown.Bold})
    Markdown.withtag(io, :strong) do
        Markdown.htmlinline(io, style(md)(md.text))
    end
end

function Markdown.htmlinline(io::IO, md::Styled{Markdown.Italic})
    Markdown.withtag(io, :em) do
        Markdown.htmlinline(io, style(md)(md.text))
    end
end

# function Markdown.htmlinline(io::IO, md::Styled{Markdown.Image})
#     Markdown.tag(io, :img, :src => md.url, :alt => md.alt)
# end

# function Markdown.htmlinline(io::IO, f::Styled{Markdown.Footnote})
#     Markdown.withtag(io, :a, :href => "#footnote-$(f.id)", :class => "footnote") do
#         print(io, "[", f.id, "]")
#     end
# end

function Markdown.htmlinline(io::IO, link::Styled{Markdown.Link})
    Markdown.withtag(io, :a, :href => link.url) do
        Markdown.htmlinline(io, style(link)(link.text))
    end
end

# function Markdown.htmlinline(io::IO, br::Styled{Markdown.LineBreak})
#     Markdown.tag(io, :br)
# end
