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
  let(:blog_comment) { blog_post.blog_comments.create(body: 'Body Test', user_id: user.id) }
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

    context 'when user is not signed in' do
      before do
        get :new, as: :turbo_stream, params: { blog_post_id: blog_post.id, parent_id: blog_comment.id }
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to log in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is signed in' do
      login_user

      before do
        get :new, as: :turbo_stream, params: { blog_post_id: blog_post.id, parent_id: blog_comment.id }
      end

      it 'authorizes to new' do
        expect do
          get :new, as: :turbo_stream, params: { blog_post_id: blog_post.id, parent_id: blog_comment.id }
        end.not_to raise_error
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(blog_comment)
      end

      it 'assigns @reply' do
        expect(assigns(:reply).attributes).to eq(blog_comment.replies.new(parent_id: blog_comment.id).attributes)
      end

      it 'renders new form' do
        expect(response).to render_template(:new)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #show' do
    let(:blog_comment2) { blog_post.blog_comments.create(body: 'Body Test 2', user_id: user.id) }

    it { is_expected.to use_before_action(:set_blog_comment) }

    it 'authorizes to show' do
      expect do
        get :show, as: :turbo_stream, params: { blog_post_id: blog_post.id, id: blog_comment.id }
      end.not_to raise_error
    end

    context 'when blog comment is not a reply' do
      login_user

      before do
        get :show, as: :turbo_stream, params: { blog_post_id: blog_post.id, id: blog_comment.id }
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_comment.blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(blog_comment)
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end

      it 'renders show' do
        expect(response).to render_template(:show)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when blog comment is a reply' do
      login_user

      before do
        blog_comment2 = blog_post.blog_comments.create(body: 'Body Test 2', user_id: user.id)
        reply = blog_comment2.replies.create(
          body: 'Reply Test',
          parent_id: blog_comment2.id,
          blog_post_id: blog_comment2.blog_post.id,
          user_id: user.id
        )
        get :show, as: :turbo_stream, params: { blog_post_id: blog_post.id, id: reply.id }
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Reply Test'))
      end

      it 'assigns @blog_comment_parent' do
        expect(assigns(:blog_comment_parent)).to eq(BlogComment.find_by(body: 'Reply Test').parent)
      end
    end
  end

  describe 'GET #edit' do
    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:set_blog_comment) }

    context 'when user is not logged in' do
      before do
        get :edit, as: :turbo_stream, params: { blog_post_id: blog_post.id, id: blog_comment.id }
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to log in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when blog comment does not belong to a logged in user' do
      login_user

      it 'does not authorizes to edit' do
        expect do
          get :edit, as: :turbo_stream, params: { blog_post_id: blog_post.id, id: blog_comment.id }
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when blog comment belongs to a logged in user' do
      login_user

      let(:blog_comment2) do
        blog_post.blog_comments.create(body: 'Body Test 2', user_id: logged_in_user.id)
      end

      before do
        get :show, as: :turbo_stream, params: { blog_post_id: blog_post.id, id: blog_comment2.id }
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(blog_comment2)
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end

      it 'renders edit form' do
        expect(response).to render_template(:show)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when reply does not belong to a logged in user' do
      login_user

      before do
        blog_comment2 = blog_post.blog_comments.create(
          body: 'Body Test 2', user_id: logged_in_user.id
        )
        blog_comment2.replies.create(
          body: 'Reply Test',
          parent_id: blog_comment2.id,
          blog_post_id: blog_comment2.blog_post.id,
          user_id: user.id
        )
      end

      it 'does not authorizes to edit' do
        expect do
          get :edit, as: :turbo_stream,
                     params: { blog_post_id: blog_post.id, id: BlogComment.find_by(body: 'Reply Test').id }
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when reply belongs to a logged in user' do
      login_user

      before do
        blog_comment2 = blog_post.blog_comments.create(
          body: 'Body Test 2', user_id: logged_in_user.id
        )
        reply = blog_comment2.replies.create(
          body: 'Reply Test',
          parent_id: blog_comment2.id,
          blog_post_id: blog_comment2.blog_post.id,
          user_id: logged_in_user.id
        )
        get :show, as: :turbo_stream, params: { blog_post_id: blog_post.id, id: reply.id }
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Reply Test'))
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end

      it 'renders show' do
        expect(response).to render_template(:show)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    let(:params) do
      { blog_comment: { body: 'Body Create Test', blog_post_id: blog_post.id, user_id: user.id, parent_id: nil },
        blog_post_id: blog_post.id }
    end

    it { is_expected.to use_before_action(:authenticate_user!) }

    context 'when user is not logged in' do
      before do
        post :create, as: :turbo_stream, params:
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to log in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is logged in' do
      login_user

      it 'authorizes to create' do
        expect do
          post :create, as: :turbo_stream, params:
        end.not_to raise_error
      end
    end

    context 'when user is creating blog comment' do
      login_user

      before do
        params[:blog_comment][:user_id] = logged_in_user.id
        post :create, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Body Create Test'))
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Comment was successfully created.')
      end

      it 'renders create' do
        expect(response).to render_template(:create)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when after blog comment is created' do
      login_user

      before do
        params[:blog_comment][:user_id] = logged_in_user.id
      end

      it 'increments Blog Comment data by 1' do
        expect { post :create, as: :turbo_stream, params: }.to change(BlogComment, :count).by(1)
      end
    end

    context 'when creating a blog comment fails' do
      login_user

      before do
        params[:blog_comment][:user_id] = logged_in_user.id
        params[:blog_comment][:body] = ''
        post :create, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        assigns(:blog_comment).attributes.each do |key, value|
          expect(params[:blog_comment][key.to_sym]).to eq(value)
        end
      end

      it 'renders create error' do
        expect(response).to render_template(:error_create)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'does not increment Blog Comment data by 1' do
        expect { post :create, as: :turbo_stream, params: }.not_to change(BlogComment, :count)
      end
    end

    context 'when user is creating reply' do
      login_user

      before do
        params[:blog_comment][:user_id] = logged_in_user.id
        params[:blog_comment][:parent_id] = blog_comment.id
        post :create, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Body Create Test'))
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Reply to a comment was successfully created.')
      end

      it 'renders create' do
        expect(response).to render_template(:create)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when after reply is created' do
      login_user

      before do
        params[:blog_comment][:user_id] = logged_in_user.id
        params[:blog_comment][:parent_id] = blog_comment.id
      end

      it 'increments Blog Comment data by 1' do
        expect { post :create, as: :turbo_stream, params: }.to change(BlogComment, :count).by(1)
      end
    end

    context 'when creating a reply fails' do
      login_user

      before do
        params[:blog_comment][:user_id] = logged_in_user.id
        params[:blog_comment][:parent_id] = blog_comment.id
        params[:blog_comment][:body] = ''
        post :create, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        assigns(:blog_comment).attributes.each do |key, value|
          expect(params[:blog_comment][key.to_sym]).to eq(value)
        end
      end

      it 'renders create error' do
        expect(response).to render_template(:error_create)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'does not increment Blog Comment data by 1' do
        expect { post :create, as: :turbo_stream, params: }.not_to change(BlogComment, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:params) do
      { id: blog_comment.id, blog_post_id: blog_post.id, blog_comment: { body: 'Body Update Test' } }
    end

    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:set_blog_comment) }

    context 'when user is not logged in' do
      before do
        post :update, as: :turbo_stream, params:
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to log in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when blog comment belongs to logged in user' do
      login_user

      before do
        blog_comment3 =
          blog_post.blog_comments.create(body: 'Body Test', user_id: logged_in_user.id)
        params[:id] = blog_comment3.id
      end

      it 'authorizes to update' do
        expect do
          post :update, as: :turbo_stream, params:
        end.not_to raise_error
      end
    end

    context 'when blog comment does not belong to logged in user' do
      login_user

      it 'does not authorize to update' do
        expect do
          post :update, as: :turbo_stream, params:
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when blog comment does not belong to an admin logged in user' do
      login_admin

      it 'authorizes to update' do
        expect do
          post :update, as: :turbo_stream, params:
        end.not_to raise_error
      end
    end

    context 'when reply belongs to logged in user' do
      login_user

      before do
        reply = blog_comment.replies.create(
          body: 'Reply Test', blog_post_id: blog_post.id, user_id: logged_in_user.id, parent_id: blog_comment.id
        )
        params[:id] = reply.id
      end

      it 'authorizes to update' do
        expect do
          post :update, as: :turbo_stream, params:
        end.not_to raise_error
      end
    end

    context 'when reply does not belong to logged in user' do
      login_user

      before do
        reply = blog_comment.replies.create(
          body: 'Reply Test', blog_post_id: blog_post.id, user_id: user.id, parent_id: blog_comment.id
        )
        params[:id] = reply.id
      end

      it 'does not authorize to update' do
        expect do
          post :update, as: :turbo_stream, params:
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when reply does not belong to an admin logged in user' do
      login_admin

      before do
        reply = blog_comment.replies.create(
          body: 'Reply Test', blog_post_id: blog_post.id, user_id: user.id, parent_id: blog_comment.id
        )
        params[:id] = reply.id
      end

      it 'authorizes to update' do
        expect do
          post :update, as: :turbo_stream, params:
        end.not_to raise_error
      end
    end

    context 'when user is updating blog comment' do
      login_user

      before do
        blog_comment3 =
          blog_post.blog_comments.create(body: 'Body Test 3', user_id: logged_in_user.id)
        params[:id] = blog_comment3.id
        post :update, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Body Update Test'))
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Comment was successfully updated.')
      end

      it 'renders update' do
        expect(response).to render_template(:update)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when blog comment update fails' do
      login_user

      before do
        blog_comment3 =
          blog_post.blog_comments.create(body: 'Body Test 3', user_id: logged_in_user.id)
        params[:id] = blog_comment3.id
        params[:blog_comment][:body] = ''
        post :update, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Body Test 3'))
      end

      it 'renders update error' do
        expect(response).to render_template(:error_update)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is updating reply' do
      login_user

      before do
        reply = blog_comment.replies.create(
          body: 'Reply Test',
          blog_post_id: blog_post.id,
          user_id: logged_in_user.id,
          parent_id: blog_comment.id
        )
        params[:id] = reply.id
        post :update, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Body Update Test'))
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Reply was successfully updated.')
      end

      it 'renders update' do
        expect(response).to render_template(:update)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when reply update fails' do
      login_user

      before do
        reply = blog_comment.replies.create(
          body: 'Reply Test',
          blog_post_id: blog_post.id,
          user_id: logged_in_user.id,
          parent_id: blog_comment.id
        )
        params[:id] = reply.id
        params[:blog_comment][:body] = ''
        post :update, as: :turbo_stream, params:
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @blog_comment' do
        expect(assigns(:blog_comment)).to eq(BlogComment.find_by(body: 'Reply Test'))
      end

      it 'renders update error' do
        expect(response).to render_template(:error_update)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    it { is_expected.to use_before_action(:authenticate_user!) }
    it { is_expected.to use_before_action(:set_blog_comment) }

    context 'when user is not logged in' do
      before do
        delete :destroy, as: :turbo_stream, params: { id: blog_comment.id, blog_post_id: blog_post.id }
      end

      it 'returns 302 status code' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to log in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when blog comment belongs to logged in user' do
      login_user

      before do
        blog_post.blog_comments.create(body: 'Body Test', user_id: logged_in_user.id)
      end

      it 'authorizes to destroy' do
        expect do
          delete :destroy, as: :turbo_stream,
                           params: { id: BlogComment.find_by(user_id: logged_in_user).id, blog_post_id: blog_post.id }
        end.not_to raise_error
      end
    end

    context 'when blog comment does not belong to logged in user' do
      login_user

      it 'does not authorize to destroy' do
        expect do
          delete :destroy, as: :turbo_stream, params: { id: blog_comment.id, blog_post_id: blog_post.id }
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when blog comment does not belong to an admin logged in user' do
      login_admin

      it 'authorizes to destroy' do
        expect do
          delete :destroy, as: :turbo_stream, params: { id: blog_comment.id, blog_post_id: blog_post.id }
        end.not_to raise_error
      end
    end

    context 'when reply belongs to logged in user' do
      login_user

      before do
        blog_comment.replies.create(
          body: 'Reply Test', blog_post_id: blog_post.id, user_id: logged_in_user.id, parent_id: blog_comment.id
        )
      end

      it 'authorizes to destroy' do
        expect do
          delete :destroy, as: :turbo_stream,
                           params: { id: BlogComment.find_by(body: 'Reply Test').id, blog_post_id: blog_post.id }
        end.not_to raise_error
      end
    end

    context 'when reply does not belong to logged in user' do
      login_user

      before do
        blog_comment.replies.create(
          body: 'Reply Test', blog_post_id: blog_post.id, user_id: user.id, parent_id: blog_comment.id
        )
      end

      it 'does not authorize to destroy' do
        expect do
          delete :destroy, as: :turbo_stream,
                           params: { id: BlogComment.find_by(body: 'Reply Test').id, blog_post_id: blog_post.id }
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when reply does not belong to an admin logged in user' do
      login_admin

      before do
        blog_comment.replies.create(
          body: 'Reply Test', blog_post_id: blog_post.id, user_id: user.id, parent_id: blog_comment.id
        )
      end

      it 'authorizes to destroy' do
        expect do
          delete :destroy, as: :turbo_stream,
                           params: { id: BlogComment.find_by(body: 'Reply Test').id, blog_post_id: blog_post.id }
        end.not_to raise_error
      end
    end

    context 'when member user is destroying blog comment' do
      login_user

      before do
        blog_comment3 =
          blog_post.blog_comments.create(body: 'Body Test 3', user_id: logged_in_user.id)
        delete :destroy, as: :turbo_stream, params: { id: blog_comment3.id, blog_post_id: blog_post.id }
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end

      it 'updates the body comment correctly' do
        expect(assigns(:blog_comment).body).to eq('Comment deleted by user')
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Comment was successfully deleted.')
      end

      it 'renders destroy' do
        expect(response).to render_template(:destroy)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'does not decrement Blog Comment data by 1' do
        expect do
          delete :destroy, as: :turbo_stream, params: { id: BlogComment.last.id, blog_post_id: blog_post.id }
        end.not_to change(BlogComment, :count)
      end
    end

    context 'when admin user is destroying blog comment that does not belong to admin user' do
      login_admin

      before do
        delete :destroy, as: :turbo_stream, params: { id: blog_comment.id, blog_post_id: blog_post.id }
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end

      it 'updates the body comment correctly' do
        expect(assigns(:blog_comment).body).to eq('Comment deleted by admin')
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Comment was successfully deleted.')
      end

      it 'renders destroy' do
        expect(response).to render_template(:destroy)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'does not decrement Blog Comment data by 1' do
        expect do
          delete :destroy, as: :turbo_stream, params: { id: blog_comment.id, blog_post_id: blog_post.id }
        end.not_to change(BlogComment, :count)
      end
    end

    context 'when member user is destroying reply' do
      login_user

      before do
        reply = blog_comment.replies.create(
          body: 'Reply Test Destroy',
          user_id: logged_in_user.id,
          blog_post_id: blog_post.id,
          parent_id: blog_comment.id
        )
        delete :destroy, as: :turbo_stream, params: { id: reply.id, blog_post_id: blog_post.id }
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end

      it 'updates the body comment correctly' do
        expect(assigns(:blog_comment).body).to eq('Comment deleted by user')
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Reply was successfully deleted.')
      end

      it 'renders destroy' do
        expect(response).to render_template(:destroy)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      # rubocop:disable RSpec/ExampleLength
      it 'does not decrement Blog Comment data by 1' do
        expect do
          delete :destroy, as: :turbo_stream,
                           params: {
                             id: BlogComment.find_by(user_id: logged_in_user.id).id, blog_post_id: blog_post.id
                           }
        end.not_to change(BlogComment, :count)
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'when admin user is destroying reply that does not belong to admin user' do
      login_admin

      before do
        reply = blog_comment.replies.create(
          body: 'Reply Test Destroy',
          user_id: user.id,
          blog_post_id: blog_post.id,
          parent_id: blog_comment.id
        )
        delete :destroy, as: :turbo_stream, params: { id: reply.id, blog_post_id: blog_post.id }
      end

      it 'assigns @blog_post' do
        expect(assigns(:blog_post)).to eq(blog_post)
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(logged_in_user)
      end

      it 'updates the body comment correctly' do
        expect(assigns(:blog_comment).body).to eq('Comment deleted by admin')
      end

      it 'has flash notice' do
        expect(flash[:notice]).to eq('Reply was successfully deleted.')
      end

      it 'renders destroy' do
        expect(response).to render_template(:destroy)
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'does not decrement Blog Comment data by 1' do
        expect do
          delete :destroy, as: :turbo_stream, params: { id: BlogComment.last.id, blog_post_id: blog_post.id }
        end.not_to change(BlogComment, :count)
      end
    end
  end
end
