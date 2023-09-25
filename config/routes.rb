# frozen_string_literal: true

Rails.application.routes.draw do
  resources :blog_posts do
    resources :blog_comments
  end
  devise_for :users
  root 'pages#home'

  delete '/blog_posts/:id/blog_comments/:id/cancel_new_form', to: 'blog_comments#cancel_new_form'
end
