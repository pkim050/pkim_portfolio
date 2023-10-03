# frozen_string_literal: true

class BlogPost < ApplicationRecord
  belongs_to :user
  has_many :blog_comments, dependent: :destroy
  validates :title, :body, presence: true
end
