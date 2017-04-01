Rails.application.routes.draw do

	root to: 'videos#index'
	resources :videos, only: [:index, :show] do
		resource :edit_title, only: [:show] do
			member do
				post :show
			end
		end
	end
	resources :users, only: [:create]
	resources :favorites, only: [:index, :show, :create, :destroy] do
		member do
			post :show
		end
	end
	resources :histories, only: [:index, :show, :create] do
		member do
			post :show
		end
	end
	resources :watch_later, only: [:index, :show, :create, :destroy] do
		member do
			post :show
		end
	end
	resources :highly_rated_videos, only: [:index, :show, :create, :destroy] do
		member do
			post :show
		end
	end
	resources :disliked_videos, only: [:update]

	resources :results, only: [:show] do
		member do
			post :show
		end
	end

	resources :tags, only: [:create, :destroy]

	get 'tags/:tag_name(/:id)' => 'tags#index', defaults: {id: 0}, constraints: {id: /\d+/}
	post 'tags/:tag_name(/:id)' => 'tags#index', defaults: {id: 0}, constraints: {id: /\d+/}

	post 'all_videos/:order(/:id)' => 'all_videos#show', defaults: {id: 0}, constraints: {order: /new|popular/, id: /\d+/}
	get 'all_videos/:order(/:id)' => 'all_videos#show', defaults: {id: 0}, constraints: {order: /new|popular/, id: /\d+/}

	resource :tag_cloud, only: [:show]

	resource :signup, only: [:show]
	resource :login,  only: [:show] do
		member do
			post :auth
		end
	end

	resource :logout, only: [:show]
	resource :about, only: [:show]
	resource :contact, only: [:show] do
		member do
			post :sendmail
		end
	end

#	resources :video_infos
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
	#match ':controller(/:action(/:id))', via: [ :get, :post, :patch ]
end
