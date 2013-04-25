module NavigationHelper
  def nav_link(link_text, link_path, options = {})
    alts = options.delete(:alts) || []
    current = current_page?(link_path) || alts.any? { |a| current_page?(a) }
    class_name = current ? 'active' : nil
    content_tag(:li, :class => class_name) do
      link_to link_text, link_path, options
    end
  end
end