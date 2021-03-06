const Bulma = Style{:bulma}
class(::Bulma) = "content"

# Block elements

function Markdown.html(io::IO, md::Styled{Markdown.Admonition,Bulma})
    Markdown.withtag(io, :article, :class => "message is-$(md.category)") do
        Markdown.withtag(io, :div, :class => "message-header") do
            Markdown.withtag(io, :p) do
                print(io, md.title)
            end
        end
        Markdown.withtag(io, :div, :class => "message-body") do
            html(io, style(md)(md.content))
        end
    end
end

# Inline elements

function Markdown.htmlinline(io::IO, md::Styled{Markdown.Image,Bulma})
    Markdown.withtag(io, :figure, :class => "image") do
        Markdown.tag(io, :img, :src => md.url, :alt => md.alt)
    end
end

# Extra elements

function Markdown.html(io::IO, md::Styled{Markdown.Table,Bulma})
    Markdown.withtag(io, :table, :class => "table") do
        Markdown.withtag(io, :thead) do
            htmltablerow(io, md, 1)
        end
        Markdown.withtag(io, :tbody) do
            for i ∈ 2:length(md.rows)
                htmltablerow(io, md, i)
            end
        end
    end
end
