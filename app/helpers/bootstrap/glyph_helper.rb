module Bootstrap
  module GlyphHelper
    def glyph(*names)
      content_tag :i, nil, :class => names.map{|name| "icon-#{name.to_s.gsub('_','-')}" }
    end
  end
end