WhatsTheDealWithRails::Application.routes.draw do
  get 'limbo' => 'sessions#limbo', :as => :limbo
  resource :session do
    member do
      get :limbo
    end
  end

  resources :users do
    member do
      put :authorize
      put :reject
    end
  end

  resources :order_logs do
    resources :orders
  end

  resource :openid_consumer do
    member do
      get :complete
    end
  end

  root :to => 'order_logs#index'
end
