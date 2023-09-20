# frozen_string_literal: true

class CreateBlogComments < ActiveRecord::Migration[7.0]
  def change
    create_table :blog_comments do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :blog_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
