# Block elements

Markdown.html(io::IO, md::Styled{Markdown.MD}) = html(io, md.content)

function Markdown.html(io::IO, header::Styled{Markdown.Header{l}}) where l
    Markdown.withtag(io, "h$l") do
        htmlinline(io, header.text)
    end
end

function Markdown.html(io::IO, code::Styled{Markdown.Code})
    Markdown.withtag(io, :pre) do
        maybe_lang = !isempty(code.language) ? Any[:class => "language-$(code.language)"] : []
        Markdown.withtag(io, :code, maybe_lang...) do
            Markdown.htmlesc(io, code.code)
            # TODO should print newline if this is longer than one line ?
        end
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.Paragraph})
    Markdown.withtag(io, :p) do
        htmlinline(io, md.content)
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.BlockQuote})
    Markdown.withtag(io, :blockquote) do
        println(io)
        html(io, md.content)
    end
end

function Markdown.html(io::IO, f::Styled{Markdown.Footnote})
    Markdown.withtag(io, :div, :class => "footnote", :id => "footnote-$(f.id)") do
        Markdown.withtag(io, :p, :class => "footnote-title") do
            print(io, f.id)
        end
        html(io, f.text)
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.Admonition})
    Markdown.withtag(io, :div, :class => "admonition $(md.category)") do
        Markdown.withtag(io, :p, :class => "admonition-title") do
            print(io, md.title)
        end
        html(io, md.content)
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.List})
    maybe_attr = md.ordered > 1 ? Any[:start => string(md.ordered)] : []
    Markdown.withtag(io, isordered(md) ? :ol : :ul, maybe_attr...) do
        for item in md.items
            println(io)
            Markdown.withtag(io, :li) do
                html(io, item)
            end
        end
        println(io)
    end
end

function Markdown.html(io::IO, md::Styled{Markdown.HorizontalRule})
    Markdown.tag(io, :hr)
end

# Inline elements

function Markdown.htmlinline(io::IO, code::Styled{Markdown.Code})
    Markdown.withtag(io, :code) do
        Markdown.htmlesc(io, code.code)
    end
end

function Markdown.htmlinline(io::IO, md::Styled{Markdown.Bold})
    Markdown.withtag(io, :strong) do
        htmlinline(io, md.text)
    end
end

function Markdown.htmlinline(io::IO, md::Styled{Markdown.Italic})
    Markdown.withtag(io, :em) do
        htmlinline(io, md.text)
    end
end

function Markdown.htmlinline(io::IO, md::Styled{Markdown.Image})
    Markdown.tag(io, :img, :src => md.url, :alt => md.alt)
end

function Markdown.htmlinline(io::IO, f::Styled{Markdown.Footnote})
    Markdown.withtag(io, :a, :href => "#footnote-$(f.id)", :class => "footnote") do
        print(io, "[", f.id, "]")
    end
end

function Markdown.htmlinline(io::IO, link::Styled{Markdown.Link})
    Markdown.withtag(io, :a, :href => link.url) do
        htmlinline(io, link.text)
    end
end

function Markdown.htmlinline(io::IO, br::Styled{Markdown.LineBreak})
    Markdown.tag(io, :br)
end
