require 'will_paginate/view_helpers/action_view.rb'

class WillPaginateRenderer < WillPaginate::ActionView::LinkRenderer
  def container_attributes
    {class: ""}
  end

  def page_number(page)
    if page == current_page
      '<li class="page-item">' + link(page, page, class: 'page-link active', rel: rel_value(page)) + '</li>'
    else
      '<li class="page-item">' + link(page, page, class: 'page-link', rel: rel_value(page)) + '</li>'
    end
  end

  def gap
    text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
    %(<span class="mr2">#{text}</span>)
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, '<', 'page-link')
  end

  def next_page
    num = @collection.current_page < total_pages && @collection.current_page + 1
    previous_or_next_page(num, '>', 'page-link next_page')
  end

  def previous_or_next_page(page, text, classname)
    if page
      '<li class="page-item">' + link(text, page, :class => classname) + '</li>'
    else
      '<li class="page-item">' + tag(:span, text, :class => classname) + '</li>'
      # tag(:span, text, :class => classname)
    end
  end
end