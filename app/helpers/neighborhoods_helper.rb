module NeighborhoodsHelper

  def link_button_to(caption, path, id, active)
    theme = active ? 'b' : 'd'
    link_to(caption, path, :method => :post, :id => id, :'data-role' => 'button', :'data-theme' => theme)
  end
end
