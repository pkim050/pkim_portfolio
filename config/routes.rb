# frozen_string_literal: true

Rails.application.routes.draw do
  get 'patch_notes', to: 'patch_notes#index'

  get 'patch_notes/:name', to: 'patch_notes#patch_note', constraints: { name: %r{[^\/]+} }, as: :patch_note

  get 'about_me', to: 'pages#about_me'

  get 'projects', to: 'pages#projects'

  resources :blog_posts do
    resources :blog_comments
  end
  devise_for :users
  root 'pages#home'

  delete '/blog_posts/:id/blog_comments/:id/cancel_new_form', to: 'blog_comments#cancel_new_form'
end
