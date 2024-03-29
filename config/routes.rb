# frozen_string_literal: true

Rails.application.routes.draw do
  get 'patch_notes', to: 'patch_notes#index'

  get 'patch_notes/:name', to: 'patch_notes#patch_note', constraints: { name: %r{[^\/]+} }, as: :patch_note

  get 'about', to: 'pages#about'

  get 'projects', to: 'pages#projects'

  get 'upload_resume', to: 'pages#upload_resume_page'

  post 'upload_resume', to: 'pages#upload_resume'

  resources :blog_posts do
    resources :blog_comments
  end

  devise_for :users

  root 'pages#home'

  delete '/blog_posts/:id/blog_comments/:id/cancel_new_form', to: 'blog_comments#cancel_new_form'

  get 'roaming_hunger', to: 'todos#index'

  post 'roaming_hunger', to: 'todos#create'

  get 'roaming_hunger/:id/edit', to: 'todos#edit'

  patch 'roaming_hunger/:id', to: 'todos#update'

  put 'roaming_hunger/:id', to: 'todos#update'

  delete 'roaming_hunger/:id', to: 'todos#destroy'

  get 'roaming_hunger/:id/toggle', to: 'todos#toggle'

  resources :todos

  namespace :api do
    namespace :v1 do
      resources :todos
    end
  end
end
