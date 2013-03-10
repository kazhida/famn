# -*- encoding: utf-8 -*-

module InfosHelper

  def about_to(caption, section)
    link_to caption, :controller => :infos, :action => :about, :remote => true, :section => section
  end

  def jump_to(caption, section)
    sanitize %!<a href="##{section}">#{caption}</a>!
  end
end
