Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'static_pages#home'
  match '/about',     to: 'static_pages#about',     via: 'get'
  match '/donate',    to: 'static_pages#donate',    via: 'get'
  match '/privacy',   to: 'static_pages#privacy',    via: 'get'
  match '/search',    to: 'static_pages#search',    via: 'get'
  match '/thanks',    to: 'static_pages#thanks',    via: 'get'
  match '/feed',      to: 'static_pages#feed',      format: 'atom', via: 'get'
  match '/instant_articles', to: 'static_pages#instant_articles',      format: 'rss', via: 'get'
  match "/sitemap",   to: 'static_pages#sitemap',   format: 'xml',  via: 'get'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

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
  # resources :magazines, only: [:show, :index]
  # resources :magazine_articles, only: [:show, :index]
  # resources :columns, only: [:show, :index]
  resources :epapers, only: [:show, :index]
  namespace :admin do
    root 'admins#index',             via: 'get', as: 'admin'
    resources :articles, except: [:show]
    resources :users, only: [:index, :update, :destroy]
    resources :sites, except: [:show]
    resources :catalogs, except: [:show] do
      put :sort, on: :collection
    end
    resources :categories, except: [:show] do
      put :sort, on: :collection
    end
    resources :keywords, except: [:show] do
      get :order, on: :collection
      get :show_order, on: :collection
      put :sort,  on: :collection
      put :show_sort,  on: :collection
      resources :faqs, only: [:index]
    end
    match 'faqs/sort',   to: 'faqs#sort',   via: 'put'
    match 'slides/sort', to: 'slides#sort', via: 'put'
    match 'sites/sort', to: 'sites#sort', via: 'put'
  end

  namespace :api, defaults: { format: 'json' } do
    resources :articles, only: [:show, :index]
    resources :keywords, only: [:show, :index]
    resources :catalogs, only: [:show, :index]
  end

  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ], as: 'not_found'
  match "/422" => "errors#error422", via: [ :get, :post, :patch, :delete ]
  match "/500" => "errors#error500", via: [ :get, :post, :patch, :delete ]

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
