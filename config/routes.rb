# frozen_string_literal: true

# route defintion
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'games#new'
  get 'session', to: 'games#reset'
  post 'score', to: 'games#score', as: :score
end
