Rails.application.routes.draw do

  resources :editions
  devise_for :admin_accounts, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'pages/terms'
  get 'pages/welcome'
  get 'pages/landing'

  devise_for :accounts, controllers: {
    confirmations: 'accounts/confirmations',
    passwords: 'accounts/passwords',
    registrations: 'accounts/registrations',
    sessions: 'accounts/sessions',
    unlocks: 'accounts/unlocks',
    omniauth_callbacks: 'accounts/omniauth_callbacks',
  }
  devise_scope :account do
    get '/account/', to: 'accounts/accounts#show', as: '/account/'

    # added to please devise
    # root to: 'accounts/sessions#new'
    root to: 'accounts/accounts#show'

    # authenticated do
    #   root to: 'accounts/accounts#show', as: :authenticated_root
    # end

  end

  resources :works do
    member do
      get :attach_file
      post :upload_file
    end
    resources :authors do
      get :select, on: :collection
    end
    resources :works_roles_authors, only: [:create], as: :roles_authors
  end
  resources :roles, except: :index do
    post :select, on: :collection
  end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
