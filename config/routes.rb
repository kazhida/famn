Famn::Application.routes.draw do

  root :to => 'entries#index'

  get 'info/about'
  get 'info/privacy_policy'

  resources :entries, :except => [:show, :edit, :update]
  resource  :session, :only   => [:new, :create, :destroy]
  resource  :account, :except => [:show]

  match '*anything' => 'error#not_found'
end
