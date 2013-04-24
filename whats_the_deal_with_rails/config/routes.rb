WhatsTheDealWithRails::Application.routes.draw do
  resources :order_logs

  root :to => 'order_logs#new'
end
