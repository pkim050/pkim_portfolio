# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/edit' do
  let(:user) do
    User.create(
      username: 'username',
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'email@email.com',
      password: 'password'
    )
  end
  let(:blog_post) { user.blog_posts.new }

  it 'renders the edit blog_post form' do
    expect(user.username).to eq('username')
  end
end
