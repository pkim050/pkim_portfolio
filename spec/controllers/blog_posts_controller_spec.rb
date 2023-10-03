# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'
require_relative '../support/devise'

RSpec.describe BlogPostsController do
  include Pagy::Backend

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
    it { is_expected.to route(:get, '/blog_posts').to(action: :index) }
    it { is_expected.to route(:get, '/blog_posts/new').to(action: :new) }
    it { is_expected.to route(:get, '/blog_posts/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get, '/blog_posts/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:post, '/blog_posts').to(action: :create) }
    it { is_expected.to route(:patch, '/blog_posts/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/blog_posts/1').to(action: :destroy, id: 1) }
  end

  describe 'GET #index' do
    let(:blog_posts) { BlogPost.order('created_at desc') }

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

    context 'when there are 10 or less blog posts' do
      before do
        9.times { BlogPost.create(title: 'Title Test', body: 'Body Test', user_id: user.id) }
      end

      it 'assigns @blog_posts' do
        pagy(blog_posts, page: 1, items: 10, count: 1)
        expect(assigns(:blog_posts)).to eq(blog_posts)
      end

      it 'assigns @records' do
        _pagy, records = pagy(blog_posts, page: 1, items: 10, count: 1)
        expect(assigns(:records)).to eq(records)
      end

      it 'matches pagy variables' do
        pagy, _records = pagy(blog_posts, page: 1, items: 10, count: 1)
        expect(assigns(:pagy).vars).to match pagy.vars
      end

      it 'has 1 page in pagy' do
        pagy(blog_posts, page: 1, items: 10, count: 1)
        expect(assigns(:pagy).pages).to eq(1)
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

    context 'when user is not signed in' do
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

    context 'when member user is signed in' do
      login_user

      it 'does not authorize to action new' do
        expect { get :new }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when admin user is signed in' do
      login_admin

      before do
        get :new
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post).attributes).to eq(BlogPost.new.attributes)
      end

      it 'renders new page' do
        expect(response).to render_template(:new)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'authorizes to action new' do
        expect { get :new }.not_to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: blog_post.id }
    end

    it { is_expected.to use_before_action(:set_blog_post) }

    it 'does not check authorizes_resource' do
      expect { get :show, params: { id: blog_post.id } }.not_to raise_error
    end

    it 'renders show page' do
      expect(response).to render_template(:show)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @blog_post' do
      expect(assigns(:blog_post)).to eq(blog_post)
    end

    context 'when user is not signed in' do
      it 'assigns @user' do
        expect(assigns(:user)).to be_nil
      end
    end

    context 'when user is signed in' do
      login_user

      it 'assigns @user' do
        get :show, params: { id: blog_post.id }
        expect(assigns(:user)).to eq(logged_in_user)
      end
    end
  end

  describe 'GET #edit' do
    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:set_blog_post) }

    context 'when user is not signed in' do
      before do
        get :edit, params: { id: blog_post.id }
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is a member' do
      login_user

      it 'does not authorizes to edit' do
        expect { get :edit, params: { id: blog_post.id } }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user is an admin' do
      login_admin

      before do
        get :edit, params: { id: blog_post.id }
      end

      it 'authorizes to edit' do
        expect { get :edit, params: { id: blog_post.id } }.not_to raise_error
      end

      it 'renders show page' do
        expect(response).to render_template(:edit)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end
    end
  end

  describe 'POST #create' do
    let(:create_params) { { blog_post: { title: 'Title Test', body: 'Body Test', user_id: logged_in_user } } }
    let(:create_params_error) { { blog_post: { body: 'Body Test', user_id: logged_in_user } } }

    it { is_expected.to use_before_action(:authenticate_user!) }

    context 'when user is not signed in' do
      before do
        post :create, params: create_params
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is a member' do
      login_user

      it 'does not authorizes to create' do
        expect { post :create, params: create_params }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user is an admin' do
      login_admin

      it 'authorizes to edit' do
        expect { post :create, params: create_params }.not_to raise_error
      end
    end

    context 'when blog post successfully saves' do
      login_admin

      before do
        post :create, params: create_params
      end

      it 'redirects to blog post show page' do
        expect(response).to redirect_to blog_post_url(BlogPost.find_by(create_params[:blog_post]))
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(BlogPost.find_by(create_params[:blog_post]))
      end

      it 'one more Blog Post' do
        expect(BlogPost.count).to eq(1)
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Blog post was successfully created.')
      end
    end

    context 'when blog post errors on save' do
      login_admin

      before do
        post :create, params: create_params_error
      end

      it 'renders new' do
        expect(response).to render_template(:new)
      end

      it 'has 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:update_params) { { id: blog_post.id, blog_post: { title: 'Update Title Test', body: 'Update Body Test' } } }
    let(:update_params_error) { { id: blog_post.id, blog_post: { title: '', body: 'Update Body Test' } } }

    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:set_blog_post) }

    context 'when user is not signed in' do
      before do
        put :update, params: update_params
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end
    end

    context 'when user is a member' do
      login_user

      it 'does not authorizes to update' do
        expect { put :update, params: update_params }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user is an admin' do
      login_admin

      before do
        put :update, params: update_params
      end

      it 'authorizes to update' do
        expect { put :update, params: update_params }.not_to raise_error
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(BlogPost.find(blog_post.id))
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end
    end

    context 'when blog post successfully saves' do
      login_admin

      before do
        put :update, params: update_params
      end

      it 'redirects to blog post show page' do
        expect(response).to redirect_to blog_post_url(BlogPost.find(blog_post.id))
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Blog post was successfully updated.')
      end
    end

    context 'when blog post errors on save' do
      login_admin

      before do
        put :update, params: update_params_error
      end

      it 'renders edit' do
        expect(response).to render_template(:edit)
      end

      it 'has 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:set_blog_post) }

    context 'when user is not signed in' do
      before do
        delete :destroy, params: { id: blog_post.id }
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end
    end

    context 'when user is a member' do
      login_user

      it 'does not authorizes to destroy' do
        expect { delete :destroy, params: { id: blog_post.id } }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user is an admin' do
      login_admin

      it 'authorizes to destroy' do
        expect { delete :destroy, params: { id: blog_post.id } }.not_to raise_error
      end
    end

    context 'when blog post successfully destroys' do
      login_admin

      before do
        delete :destroy, params: { id: blog_post.id }
      end

      it 'one less Blog Post' do
        expect(BlogPost.count).to eq(0)
      end

      it 'redirects to blog post index page' do
        expect(response).to redirect_to blog_posts_url
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Blog post was successfully destroyed.')
      end
    end
  end
end
