module ApplicationHelper
  def navbar_link(text, url)
    button_class = 'button btn btn-default navbar-btn navbar-left'
    button_class += ' current' if current_page? url
    link_to url do
      content_tag :button, text, class: button_class
    end
  end
end
