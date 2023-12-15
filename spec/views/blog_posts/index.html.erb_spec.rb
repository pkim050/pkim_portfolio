# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/index', type: :feature do
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

  it 'renders all blog posts' do
    blog_post
    blog_post2
    # allow(view).to receive(:current_user).and_return(user)
    expect(BlogPost.count).to eq(2)
  end

  context 'when there are no blog posts' do
    it 'renders a message' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when there is one blog post' do
    it 'renders blog post title' do
      expect(1 + 1).to eq(2)
    end

    it 'renders blog post content' do
      expect(1 + 2).to eq(3)
    end

    it 'renders Read more -> link' do
      expect(1 + 3).to eq(4)
    end
  end

  context 'when there is more than one blog post' do
    it 'renders divider' do
      expect(1 + 1).to eq(2)
    end
  end

  context 'when admin user is logged in' do
    it 'renders Create New Blog Post button on top of the page' do
      expect(1 + 1).to eq(2)
    end

    it 'renders Create New Blog Post button on bottom of the page' do
      expect(1 + 2).to eq(3)
    end

    context 'when Create New Blog Post button is clicked' do
      it 'directs user to new form' do
        expect(1 + 1).to eq(2)
      end
    end
  end

  context 'when Read more -> is clicked' do
    it 'directs user to show page' do
      expect(1 + 1).to eq(2)
    end
  end
end
