Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'static_pages#home'
  match '/about',     to: 'static_pages#about',     via: 'get'
  match '/donate',    to: 'static_pages#donate',    via: 'get'
  match '/search',    to: 'static_pages#search',    via: 'get'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :articles, only: [:show, :index] do
    get :presses, on: :collection
    get :activities, on: :collection
    get :comments, on: :collection
    get :epapers, on: :collection
    get :books, on: :collection
  end
  resources :keywords, only: [:show]
  # resources :catalogs
  # resources :categories
  # resources :kinds, only: [:show, :index]
  resources :magazines
  resources :magazine_articles
  resources :columns
  resources :epapers, only: [:show, :index]
  namespace :admin do
    root 'admins#index',             via: 'get', as: 'admin'
    resources :articles, except: [:show]
    resources :users, only: [:index, :update]
    resources :catalogs, except: [:show] do
      put :sort, on: :collection
    end
    resources :categories, except: [:show] do
      put :sort, on: :collection
    end
    resources :keywords, except: [:show] do
      put :sort, on: :collection
    end
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
