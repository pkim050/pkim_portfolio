# frozen_string_literal: true

Rails.application.routes.draw do
  resources :blog_posts do
    resources :blog_comments
  end
  devise_for :users
  root 'pages#home'
end
