# -*- encoding: utf-8 -*-

module ApplicationHelper

  def with_html_format(&block)
    tmp = formats
    begin
      formats = [:html]
      result = block.call
    ensure
      formats = tmp
    end
    result
  end
end
