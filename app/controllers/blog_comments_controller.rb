# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_blog_comment, only: %i[edit update destroy]

  def index
    @blog_comments = BlogComment.all
  end

  def show
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog_comment = @blog_post.blog_comments.find_by(id: params[:id])

    respond_to do |format|
      format.html { redirect_to blog_post_url(@blog_post), notice: t('.success_reply') }
      format.turbo_stream { render :show, locals: { blog_comment: @blog_comment } }
      format.json { render :show, status: :ok, location: @blog_post }
    end
  end

  def new
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog_comment = @blog_post.blog_comments.find_by(id: params[:parent_id])
    @reply = @blog_comment.replies.new(parent_id: params[:parent_id])
  end

  # GET /blog_comments/1/edit
  def edit
    respond_to do |format|
      format.html { redirect_to blog_post_url(@blog_post), notice: t('.success_reply') }
      format.turbo_stream { render :edit, locals: { blog_comment: @blog_comment } }
      format.json { render :show, status: :ok, location: @blog_post }
    end
  end

  # POST /blog_comments or /blog_comments.json
  def create
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog_comment = @blog_post.blog_comments.new(blog_comment_params)

    if @blog_comment.save
      render_comment_or_reply(@blog_comment)
    else
      render_comment_error_or_reply_error(@blog_comment)
    end
  end

  # PATCH/PUT /blog_comments/1 or /blog_comments/1.json
  def update
    if @blog_comment.update(blog_comment_params)
      flash.now[:notice] = t('.success')
    else
      flash.now[:error] = t('.error')
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
      flash.now[:notice] = t('.success')
    else
      flash.now[:error] = t('.error')
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

  def render_comment_or_reply(blog_comment)
    respond_to do |format|
      if blog_comment.parent_id
        flash.now[:notice] = t('.success_reply')
        format.turbo_stream { render :create_reply, locals: { blog_comment: } }
      else
        flash.now[:notice] = t('.success_comment')
        format.turbo_stream { render :create, locals: { blog_comment: } }
      end
    end
  end

  def render_comment_error_or_reply_error(blog_comment)
    @reply = blog_comment
    respond_to do |format|
      if blog_comment.parent_id
        flash.now[:error] = t('.error_reply')
        format.turbo_stream { render :error_reply, status: :unprocessable_entity, locals: { reply: @reply } }
      else
        flash.now[:error] = t('.error_comment')
        format.turbo_stream { render :error_blog_comment, status: :unprocessable_entity, locals: { blog_comment: } }
      end
    end
  end
end
