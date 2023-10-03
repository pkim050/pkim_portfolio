# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'
require_relative '../support/devise'

RSpec.describe BlogCommentsController do
  let(:user) do
    User.create(
      username: 'username_test',
      first_name: 'first_name_test',
      last_name: 'last_name_test',
      email: 'test@gmail.com',
      password: 'password_test',
      role: 'admin'
    )
  end
  let(:blog_post) { BlogPost.create(title: 'Title Test', body: 'Body Test', user_id: user.id) }
  let(:logged_in_user) do
    if User.find_by(username: 'admin_username_test')
      User.find_by(username: 'admin_username_test')
    elsif User.find_by(username: 'member_username_test')
      User.find_by(username: 'member_username_test')
    end
  end

  describe 'routes' do
    it { is_expected.to route(:get, '/blog_posts/1/blog_comments').to(action: :index, blog_post_id: 1) }
    it { is_expected.to route(:get, '/blog_posts/1/blog_comments/new').to(action: :new, blog_post_id: 1) }
    it { is_expected.to route(:get, '/blog_posts/1/blog_comments/1').to(action: :show, blog_post_id: 1, id: 1) }
    it { is_expected.to route(:get, '/blog_posts/1/blog_comments/1/edit').to(action: :edit, blog_post_id: 1, id: 1) }
    it { is_expected.to route(:post, '/blog_posts/1/blog_comments').to(action: :create, blog_post_id: 1) }
    it { is_expected.to route(:patch, '/blog_posts/1/blog_comments/1').to(action: :update, blog_post_id: 1, id: 1) }
    it { is_expected.to route(:delete, '/blog_posts/1/blog_comments/1').to(action: :destroy, blog_post_id: 1, id: 1) }
  end

  describe 'GET #index' do
    it 'raises exception' do
      expect do
        get :index,
            params: { blog_post_id: blog_post.id }
      end.to raise_error(ActionController::MissingExactTemplate)
    end
  end

  describe 'GET #new' do
    it { is_expected.to use_before_action(:authenticate_user!) }
  end

  # TODO: Finish up the rest of the testing
end
