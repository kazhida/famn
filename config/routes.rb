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
  resource  :account, :only   => [:edit, :update] do
    get  :unverified
  end
  resources :users,   :except => [:edit, :update]
  resource :neighborhoods, :only => [:show] do
    post :accept
    post :reject
    post :suspend
  end

  get 'v/:id/:token' => 'accounts#verify', id: /\d+/, token: /[0-9a-f]+/, :as => :account_verification

  match '*anything' => 'errors#404'
end
