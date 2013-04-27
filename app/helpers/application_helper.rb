module ApplicationHelper
  # When called within a view, this places the given string argument into a
  # content_for key called :subtitle.  The main application layout uses this
  # in the page title.
  def subtitle(page_subtitle)
    content_for(:subtitle, page_subtitle.to_s)
  end
end
