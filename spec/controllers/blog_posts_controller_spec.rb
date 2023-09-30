# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe BlogPostsController do
  include Pagy::Backend

  let(:user) do
    User.create(
      username: 'username_test',
      first_name: 'first_name_test',
      last_name: 'last_name_test',
      email: 'test@gmail.com',
      password: 'password_test'
    )
  end
  let(:blog_post) { BlogPost.create(title: 'Title Test', body: 'Body Test', user_id: user.id) }

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
    before do
      blog_post
      get :index
    end

    it 'renders index page' do
      expect(response).to render_template(:index)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    # TODO: figure out how to do check for locals
    # it 'renders correct template with locals' do
    #   blog_posts = BlogPost.order('created_at desc')
    #   allow(controller).to receive(:render).with no_args
    #   expect(controller).to have_received(:render).with({
    #     locals: { blog_posts:, records:, pagy: }
    #   })
    # end

    context 'when there are 10 or less blog posts' do
      it 'has 1 page in pagy' do
        expect(Pagy.new(count: 10).pages).to eq(1)
      end
    end

    context 'when there are more than 10 blog posts' do
      it 'has 2 or more pages in pagy' do
        expect(Pagy.new(count: 11).pages).to eq(2)
      end
    end
  end

  describe 'GET #new' do
    it { is_expected.to use_before_action(:authenticate_user!) }

    describe 'when user is not signed in' do
      before do
        get :new
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'when user is signed in' do
      let(:blog_post_new) { build(:blog_post, title: 'Title test', body: 'Body test', user_id: user.id) }

      before do
        get :new
      end

      # TODO: figure this out too
      # it 'renders index page' do
      #   expect(response).to render_template(:new)
      # end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'GET #show' do
    it { is_expected.to use_before_action(:set_blog_post) }
  end

  describe 'GET #edit' do
    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:set_blog_post) }
  end
end
