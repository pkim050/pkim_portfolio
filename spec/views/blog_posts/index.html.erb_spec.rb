# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/index' do
  let(:user) do
    User.create(
      username: 'username',
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'email@email.com',
      password: 'password'
    )
  end
  let(:blog_post) { user.blog_posts.create(title: 'Title', body: 'Body') }
  let(:blog_post2) { user.blog_posts.create(title: 'Title2', body: 'Body2') }

  it 'renders a list of blog_posts' do
    blog_post
    blog_post2
    expect(BlogPost.count).to eq(2)
  end
end
