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

  def google_ad?
    ENV['FAMN_GOOGLE_AD_SLOT'] && ENV['FAMN_GOOGLE_AD_CLIENT'] && ENV['FAMN_GOOGLE_AD_SCRIPT']
  end

  def google_ad_client
    ENV['FAMN_GOOGLE_AD_CLIENT']
  end

  def google_ad_slot
    ENV['FAMN_GOOGLE_AD_SLOT']
  end

  def google_ad_script
    ENV['FAMN_GOOGLE_AD_SCRIPT']
  end

  def google_ad_width
    ENV['FAMN_GOOGLE_AD_WIDTH'] || 200
  end

  def google_ad_height
    ENV['FAMN_GOOGLE_AD_HEIGHT'] || 200
  end

  def value_commerce_gadget?
    ENV.has_key?('FAMN_VALUE_COMMERCE_GADGET')
  end

  def value_commerce_gadget
    ENV['FAMN_VALUE_COMMERCE_GADGET'].html_safe
  end

  def value_commerce_fragment?(idx)
    ENV.has_key?("FAMN_VALUE_COMMERCE_FRAGMENT_#{idx}")
  end

  def value_commerce_fragment(idx)
    ENV["FAMN_VALUE_COMMERCE_FRAGMENT_#{idx}"].html_safe
  end

  def icon_faces
    [
        :gray,
        :blue,
        :brown,
        :green,
        :orange,
        :purple,
        :red,
        :pink,
        :black
    ]
  end
end
