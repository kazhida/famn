# -*- encoding: utf-8 -*-

module ApplicationHelper

  def nav_item(name, options = {}, html_options = {})
    cls = current_page?(options) ? ' class="active"' : ''
    "<li#{cls}>" + link_to(name, options, html_options) + '</li>'
  end

  def send_to(user)
    caption = "#{user.display_name} (@#{user.login_name})"
    link_to caption, {:controller => :entries, :action => :new, :send_to => user.login_name}
  end
end
