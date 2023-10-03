# frozen_string_literal: true

json.array! @blog_posts, partial: 'blog_posts/blog_post', as: :blog_post
