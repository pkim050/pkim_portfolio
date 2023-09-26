# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_blog_comment, only: %i[edit update destroy]
  before_action :owner?, only: %i[edit update destroy]

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

    respond_to do |format|
      format.html { redirect_to blog_post_url(@blog_post) }
      format.turbo_stream { render :new, locals: { reply: @reply } }
      format.json { render :show, status: :ok, location: @blog_post }
    end
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

    respond_to do |format|
      if @blog_comment.save && @blog_comment.parent_id
        format.html { redirect_to blog_post_url(@blog_post), notice: t('.success_reply') }
        format.turbo_stream { render :create_reply, locals: { blog_comment: @blog_comment } }
        format.json { render :show, status: :ok, location: @blog_post }
      elsif @blog_comment.save && @blog_comment.parent_id.nil?
        format.html { redirect_to blog_post_url(@blog_post), notice: t('.success_comment') }
        format.turbo_stream { render :create, locals: { blog_comment: @blog_comment } }
        format.json { render :show, status: :ok, location: @blog_post }
      elsif !@blog_comment.save && @blog_comment.parent_id.nil?
        format.html { redirect_to blog_post_url(@blog_post), notice: @blog_comment.errors.full_messages }
        format.turbo_stream {
          render :error_blog_comment, status: :unprocessable_entity, locals: { blog_comment: @blog_comment }
        }
        format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
      else
        @reply = @blog_comment
        format.html { redirect_to blog_post_url(@blog_post), notice: @blog_comment.errors.full_messages }
        format.turbo_stream { render :error_reply, status: :unprocessable_entity, locals: { reply: @reply } }
        format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_comments/1 or /blog_comments/1.json
  def update
    respond_to do |format|
      if @blog_comment.update(blog_comment_params)
        format.html { redirect_to blog_post_url(@blog_post), notice: t('.success') }
        format.turbo_stream { render :update, locals: { blog_comment: @blog_comment } }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { redirect_to blog_post_url(@blog_post), notice: @blog_comment.errors.full_messages }
        format.turbo_stream { render :error_reply, status: :unprocessable_entity, locals: { blog_comment: @blog_comment }}
        format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_comments/1 or /blog_comments/1.json
  def destroy
    @blog_comment.body = if @user.id == @blog_comment.user_id
                           'Comment deleted by user'
                         else
                           'Comment deleted by admin'
                         end

    respond_to do |format|
      if @blog_comment.save
        format.html { redirect_to blog_comment_url, notice: t('.success') }
        format.turbo_stream { render :destroy, locals: { blog_comment: @blog_comment } }
        format.json { render :show, status: :ok, location: @blog_post }
      end
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

  def owner?
    return false unless @blog_comment.user != current_user

    redirect_to blog_post_url(@blog_post), error: 'You do not have permission to access this.'
  end
end
