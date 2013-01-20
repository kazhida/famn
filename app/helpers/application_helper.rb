# -*- encoding: utf-8 -*-

module ApplicationHelper

  def with_html_format(view, &block)
    tmp = view.formats
    begin
      view.formats = [:html]
      result = block.call
    ensure
      view.formats = tmp
    end
    result
  end
end
