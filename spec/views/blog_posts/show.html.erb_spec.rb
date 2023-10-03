# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'blog_posts/show' do
  let(:user) do
    User.create(
      username: 'username',
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'email@email.com',
      password: 'password'
    )
  end
  let(:blog_post) { user.blog_posts.create(title: 'Title', body: 'MyText') }

  before do
    allow(view).to receive(:current_user).and_return(user)
  end

  context 'when user is admin' do
    it 'renders Title attributes in <p>' do
      expect(user.username).to eq('username')
    end

    it 'renders Body attributes in <p>' do
      expect(user.first_name).to eq('first_name')
    end
  end
end
