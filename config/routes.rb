Famn::Application.routes.draw do

  root :to => 'entries#index'

  resource :infos, :only => [] do
    get :about
    get :privacy_policy
  end

  resources :entries, :except => [:show, :edit, :update]
  resource  :session, :only   => [:new, :create, :destroy]
#  resource  :account, :except => [:show]
  resource  :account, :only   => [:edit, :update]

  match '*anything' => 'error#not_found'
end
