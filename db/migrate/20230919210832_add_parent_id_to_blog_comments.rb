# frozen_string_literal: true

class AddParentIdToBlogComments < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_comments, :parent_id, :integer
  end
end
