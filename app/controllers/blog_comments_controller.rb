# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_blog_comment, only: %i[show edit update destroy]

  def index
    @blog_comments = BlogComment.all
  end

  def show
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

    respond_to do |format|
      if @blog_comment.save
        create_comment_success(format, @blog_post, @blog_comment, @blog_comment.parent_id)
      else
        create_comment_error(format, @blog_post, @blog_comment, @blog_comment.parent_id)
      end
    end
  end

  # PATCH/PUT /blog_comments/1 or /blog_comments/1.json
  def update
    respond_to do |format|
      if @blog_comment.update(blog_comment_params)
        create_comment_success(format, @blog_post, @blog_comment, @blog_comment.parent_id)
      else
        create_comment_error(format, @blog_post, @blog_comment, @blog_comment.parent_id)
      end
    end
    render :update, locals: { blog_comment: @blog_comment, reply: @blog_comment }
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
    render :destroy, locals: { blog_comment: @blog_comment, reply: @blog_comment }
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

  def parent_id_check_on_create_success(format, blog_post, blog_comment, parent_id)
    if parent_id
      create_reply_success(format, blog_post, blog_comment)
    else
      create_comment_success(format, blog_post, blog_comment)
    end
  end

  def parent_id_check_on_create_error(format, blog_post, blog_comment, parent_id)
    if parent_id
      create_reply_error(format, blog_post, blog_comment)
    else
      create_comment_error(format, blog_post, blog_comment)
    end
  end

  def create_comment_success(format, blog_post, blog_comment)
    flash.now[:notice] = t('.comment_success')
    format.html { redirect_to blog_post_url(blog_post), notice: t('.reply_success') }
    format.json { render :show, status: :created, location: blog_post }
    format.turbo_stream { render :create, locals: { blog_post:, blog_comment:, user: current_user } }
  end

  def create_comment_error(format, blog_post, blog_comment)
    flash.now[:error] = t('.comment_error')
    format.html { redirect_to blog_post_url(blog_post), status: :unprocessable_entity }
    format.json { render json: blog_comment.errors, status: :unprocessable_entity }
    format.turbo_stream { render :error_blog_comment, locals: { blog_post:, blog_comment:, user: current_user } }
  end

  def create_reply_success(format, blog_post, blog_comment)
    flash.now[:notice] = t('.reply_success')
    format.html { redirect_to blog_post_url(blog_post), notice: t('.reply_success') }
    format.json { render :show, status: :created, location: blog_post }
    format.turbo_stream { render :create_reply, locals: { blog_post:, reply: blog_comment, user: current_user } }
  end

  def create_reply_error(format, blog_post, reply)
    flash.now[:error] = t('.reply_error')
    format.html { redirect_to blog_post_url(blog_post), status: :unprocessable_entity }
    format.json { render json: reply.errors, status: :unprocessable_entity }
    format.turbo_stream { render :error_reply, locals: { blog_post:, reply:, user: current_user } }
  end

  def parent_id_check_on_update_success(format, blog_post, blog_comment, parent_id)
    if parent_id
      update_reply_success(format, blog_post, blog_comment)
    else
      update_comment_success(format, blog_post, blog_comment)
    end
  end

  def parent_id_check_on_update_error(format, blog_post, blog_comment, parent_id)
    if parent_id
      update_reply_error(format, blog_post, blog_comment)
    else
      update_comment_error(format, blog_post, blog_comment)
    end
  end

  def update_comment_success(format, blog_post, blog_comment)
    flash.now[:notice] = t('.comment_success')
    format.html { redirect_to blog_post_url(blog_post), notice: t('.reply_success') }
    format.json { render :show, status: :ok, location: blog_post }
    format.turbo_stream { render :update, locals: { blog_post:, blog_comment:, user: current_user } }
  end

  def update_comment_error(format, blog_post, blog_comment)
    flash.now[:error] = t('.comment_error')
    format.html { redirect_to blog_post_url(blog_post), status: :unprocessable_entity }
    format.json { render json: blog_comment.errors, status: :unprocessable_entity }
    format.turbo_stream { render :error_blog_comment, locals: { blog_post:, blog_comment:, user: current_user } }
  end

  def update_reply_success(format, blog_post, blog_comment)
    flash.now[:notice] = t('.reply_success')
    format.html { redirect_to blog_post_url(blog_post), notice: t('.reply_success') }
    format.json { render :show, status: :ok, location: blog_post }
    format.turbo_stream { render :update, locals: { blog_post:, reply: blog_comment, user: current_user } }
  end

  def update_reply_error(format, blog_post, reply)
    flash.now[:error] = t('.reply_error')
    format.html { redirect_to blog_post_url(blog_post), status: :unprocessable_entity }
    format.json { render json: reply.errors, status: :unprocessable_entity }
    format.turbo_stream { render :error_reply, locals: { blog_post:, reply:, user: current_user } }
  end
end
