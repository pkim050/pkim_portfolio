# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_blog_comment, only: %i[show edit update destroy]

  def index
    @blog_comments = BlogComment.all
  end

  def show
    render :show, locals: { blog_comment: @blog_comment }
  end

  def new
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog_comment = @blog_post.blog_comments.find_by(id: params[:parent_id])
    @reply = @blog_comment.replies.new(parent_id: params[:parent_id])

    render :new, locals: { blog_post: @blog_post, blog_comment: @blog_comment, reply: @reply, user: current_user }
  end

  # GET /blog_comments/1/edit
  def edit
    render :edit, locals: { blog_post: @blog_post, blog_comment: @blog_comment }
  end

  # POST /blog_comments or /blog_comments.json
  def create
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog_comment = @blog_post.blog_comments.new(blog_comment_params)

    if @blog_comment.save
      successful_comment_or_reply_check(@blog_post, @blog_comment, current_user, @blog_comment.parent_id, :create)
    else
      error_comment_or_reply_check(@blog_post, @blog_comment, current_user, @blog_comment.parent_id, :error_create)
    end
  end

  # PATCH/PUT /blog_comments/1 or /blog_comments/1.json
  def update
    if @blog_comment.update(blog_comment_params)
      successful_comment_or_reply_check(@blog_post, @blog_comment, @user, @blog_comment_parent, :update)
    else
      error_comment_or_reply_check(@blog_post, @blog_comment, @user, @blog_comment_parent, :error_update)
    end
  end

  # DELETE /blog_comments/1 or /blog_comments/1.json
  def destroy
    @blog_comment.body = if @user.id == @blog_comment.user_id
                           'Comment deleted by user'
                         else
                           'Comment deleted by admin'
                         end
    if @blog_comment.save
      successful_comment_or_reply_check(@blog_post, @blog_comment, @user, @blog_comment_parent, :destroy)
    else
      redirect_to blog_post_url(blog_post), notice: t('.comment_error') unless @blog_comment_parent
      redirect_to blog_post_url(blog_post), notice: t('.reply_error')
    end
  end

  def cancel_new_form; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_blog_comment
    @blog_comment = BlogComment.find(params[:id])
    @blog_post = @blog_comment.blog_post
    @user = current_user
    return if @blog_comment.parent_id.blank?

    @blog_comment_parent = @blog_comment.parent
  end

  # Only allow a list of trusted parameters through.
  def blog_comment_params
    params.require(:blog_comment).permit(:body, :user_id, :blog_post_id, :parent_id)
  end

  def successful_comment_or_reply_check(blog_post, blog_comment, user, blog_comment_parent, action)
    if blog_comment_parent
      flash.now[:notice] = t('.reply_success')
      render action, locals: { blog_post:, blog_comment: blog_comment.parent, reply: blog_comment, user: }
    else
      flash.now[:notice] = t('.comment_success')
      render action, locals: { blog_post:, blog_comment:, reply: nil, user: }
    end
  end

  def error_comment_or_reply_check(blog_post, blog_comment, user, blog_comment_parent, action)
    if blog_comment_parent
      render action, locals: { blog_post:, blog_comment: blog_comment.parent, reply: blog_comment, user: }
    else
      render action, locals: { blog_post:, blog_comment:, reply: nil, user: }
    end
  end
end
