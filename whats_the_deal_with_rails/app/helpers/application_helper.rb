module ApplicationHelper
  def subtitle(page_subtitle)
    content_for(:subtitle, page_subtitle.to_s)
  end
end
