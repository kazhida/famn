Famn::Application.routes.draw do

  root :to => 'entries#index'

  resource :infos, :only => [] do
    get :about
    get :privacy_policy
  end

  resources :entries, :except => [:show, :edit, :update] do
    get 'page/:page', :action => :index, :on => :collection
  end
  resource  :session, :only   => [:new, :create, :destroy]
  resource  :account, :except => [:index, :show]
#  resource  :account, :only   => [:edit, :update]

  match '*anything' => 'error#not_found'
end
