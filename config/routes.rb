Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "user/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  get 'search_stocks', to: 'stocks#search'
  resources :user_stocks, except: [:show, :edit, :update]

  # for the my_friend page
  resources :users, only: [:show]
  resources :friendships
  # for the friend lookup
  get 'search_friends', to: 'users#search'
  post 'add_friend', to: 'users#add_friend'
end
