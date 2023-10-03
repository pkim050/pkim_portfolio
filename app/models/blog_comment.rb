# frozen_string_literal: true

class BlogComment < ApplicationRecord
  belongs_to :user
  belongs_to :blog_post
  belongs_to :parent, class_name: 'BlogComment', optional: true
  has_many :replies, class_name: 'BlogComment', foreign_key: :parent_id, dependent: :destroy, inverse_of: false
  validates :body, presence: true
end
