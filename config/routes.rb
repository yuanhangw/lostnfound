Dandelion::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "smokes/new"

  match '/help',  :to => 'static_pages#help'
  match '/about', :to => 'static_pages#about'
  match '/contact', :to => 'static_pages#contact'
  # match '/', :to => 'static_pages#home'

  #omniauth routes
  #facebook alone
  #match '/auth/:authorization/callback' => 'sessions#omni_create'
  
  match '/auth/:authorization/callback' => 'authorizations#create'
  match '/auth/logout' => 'sessions#omniauth_destroy'

  # need those to build a authoration page
  # match "/signin" => "services#signin"
  # match "/signout" => "services#signout"

   resources :authorizations, :only => [:index, :create, :destroy] do
      collection do
        get 'signin'
        get 'signout'
        get 'signup'
        post 'newaccount'
        get 'failure'
      end
    end



  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :wolves,   :only => [:create, :destroy, :index, :show]
  resources :smokes
  resources :shoots
  resources :praises

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # root :to => 'users#index'
  root :to => 'static_pages#home'

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy', :via => :delete
  match '/events', :to => 'wolves#index'
  match '/event', :to => 'wolves#show'  
  match '/spread/:token', :to => 'smokes#show', :via => :get

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
