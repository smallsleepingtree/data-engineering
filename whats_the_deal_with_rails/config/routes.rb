WhatsTheDealWithRails::Application.routes.draw do
  get 'limbo' => 'sessions#limbo', :as => :limbo
  resource :session do
    member do
      get :limbo
    end
  end

  resources :order_logs

  root :to => 'order_logs#index'
end
