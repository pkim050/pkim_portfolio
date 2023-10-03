# frozen_string_literal: true

json.extract! blog_comment, :id, :body, :created_at, :updated_at
json.url blog_comment_url(blog_comment, format: :json)
