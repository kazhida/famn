# -*- encoding: utf-8 -*-

module ApplicationHelper

  def nav_item(name, options = {}, html_options = {})
    cls = current_page?(options) ? ' class="active"' : ''
    "<li#{cls}>" + link_to(name, options, html_options) + '</li>'
  end
end
