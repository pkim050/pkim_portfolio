# frozen_string_literal: true

class AddUserIdToBlogPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :blog_posts, :user
    add_foreign_key :blog_posts, :users
  end
end
