# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'blog_posts/index', type: :feature do
  let(:admin_user) do
    User.create(
      username: 'admin_username',
      first_name: 'admin_first_name',
      last_name: 'admin_last_name',
      email: 'admin_email@email.com',
      password: 'admin_password',
      role: 1
    )
  end
  let(:user) do
    User.create(
      username: 'username',
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'email@email.com',
      password: 'password'
    )
  end
  let(:blog_post) { admin_user.blog_posts.create(title: 'Title', body: 'Body') }
  let(:blog_post2) { admin_user.blog_posts.create(title: 'Title2', body: 'Body2') }

  context 'when there are no blog posts' do
    it 'renders a message' do
      visit blog_posts_path
      expect(page).to have_content(
        'Looks like there are no blog posts from Patrick, let him know so that he can create his first blog post!'
      )
    end
  end

  context 'when there is one or more blog post(s)' do
    before do
      blog_post
      blog_post2
      visit blog_posts_path
    end

    it 'renders blog post title' do
      expect(page).to have_css("#blog_post_#{blog_post.id} strong", text: blog_post.title)
    end

    it 'renders blog post content' do
      expect(page).to have_css("#blog_post_#{blog_post2.id} span.line-clamp-3", text: blog_post2.body)
    end

    it 'renders Read more -> link' do
      expect(page).to have_css("#blog_post_#{blog_post.id} button a.underline", text: 'Read more ->')
    end
  end

  context 'when admin user is logged in' do
    before do
      login_as admin_user
      visit blog_posts_path
    end

    it 'renders Create New Blog Post button' do
      expect(page).to have_css('a', text: 'Create New Blog Post')
    end

    it 'has two Create New Blog Post button' do
      expect(page).to have_css('a', text: 'Create New Blog Post', count: 2)
    end

    context 'when Create New Blog Post button is clicked' do
      it 'directs user to new form' do
        find(:xpath, "//a[@href='/blog_posts/new']", match: :first).click
        expect(page).to have_current_path(new_blog_post_path)
      end
    end
  end

  context 'when non-admin user or no user is logged in' do
    before do
      login_as user
      visit blog_posts_path
    end

    it 'does not render Create New Blog Post button' do
      expect(page).not_to have_css('a', text: 'Create New Blog Post')
    end
  end

  context 'when Read more -> is clicked' do
    it 'directs user to show page' do
      blog_post
      visit blog_posts_path
      click_link 'Read more ->'
      expect(page).to have_current_path(blog_post_path(blog_post))
    end
  end
end
