Spree::Core::Engine.routes.append do
  
  scope(:module => "blogs") do

    namespace :admin do
      
      resources :blogs, :constraints => { :id => /[a-z0-9\-\_\/]{3,}/ }
      
      resources :posts do 
        resources :images,   :controller => "post_images" do
          collection do
            post :update_positions
          end
        end
        resources :products, :controller => "post_products"
        resources :categories, :controller => "post_categories"
      end
      
      resource :disqus_settings
      
    end
     
    constraints :blog_id => /([a-z0-9\-\_\/]{3,})/ do
      
      constraints(
        :year  => /\d{4}/,
        :month => /\d{1,2}/,
        :day   => /\d{1,2}/
      ) do 
        get "blogs/:blog_id/:year(/:month(/:day))" => "posts#index", :as => :post_date
        get "blogs/:blog_id/:year/:month/:day/:id" => "posts#show",  :as => :full_post
      end
      
      get "blogs/:blog_id/category/:id"   => "post_categories#show", :as => :post_category, :constraints => { :id => /.*/ }
      get "blogs/:blog_id/search/:query"  => "posts#search",         :as => :search_posts, :query => /.*/
      get "blogs/:blog_id/archive"        => "posts#archive",        :as => :archive_posts
      get "blogs/:blog_id"                => "posts#index",          :as => :blog_posts
    
    end
    
  end

end
