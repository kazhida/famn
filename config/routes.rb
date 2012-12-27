Famn::Application.routes.draw do

  root :to => 'entries#index'

  resources :entries, :except => [:show, :edit, :update]
  resource  :session, :only => [:new, :create, :destroy]

  match '*anything' => 'error#not_found'
end
