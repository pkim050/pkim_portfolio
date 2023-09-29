# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogPostsController do
  describe 'routes' do
    it { is_expected.to route(:get, '/blog_posts').to(action: :index) }
    it { is_expected.to route(:get, '/blog_posts/new').to(action: :new) }
    it { is_expected.to route(:get, '/blog_posts/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get, '/blog_posts/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:post, '/blog_posts').to(action: :create) }
    it { is_expected.to route(:patch, '/blog_posts/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/blog_posts/1').to(action: :destroy, id: 1) }
  end

  describe 'GET #index' do
    let(:user) do
      User.create(
        username: 'username_test',
        first_name: 'first_name_test',
        last_name: 'last_name_test',
        email: 'test@gmail.com',
        password: 'password_test'
      )
    end

    context 'when there are 10 or less blog posts' do
      before do
        10.times { BlogPost.create(title: 'Title Test', body: 'Body Test', user_id: user.id) }
        get 'index'
      end

      it 'all blog posts will be displayed with no pagination showing' do
        expect(BlogPost.count).to eq(10)
      end
    end
  end
end
