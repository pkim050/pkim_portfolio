# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  before_action :set_blog_comment, only: %i[show edit update destroy]

  def index
    @blog_comments = BlogComment.all
  end

  def show; end

  def new
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog_comment = @blog_post.blog_comments.new(parent_id: params[:parent_id])

    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  # GET /blog_comments/1/edit
  def edit; end

  # POST /blog_comments or /blog_comments.json
  def create
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog_comment = @blog_post.blog_comments.new(blog_comment_params)
    Rails.logger.info("CONTROLLER TEST CREATE: #{params}")

    respond_to do |format|
      if @blog_comment.save
        format.html { redirect_to blog_post_url(@blog_post), notice: 'Comment was successfully created.' } # changed the redirect to @post
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { redirect_to blog_post_url(@blog_post), notice: @blog_comment.errors.full_messages }
        format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_comments/1 or /blog_comments/1.json
  def update
    @blog_comment = BlogComment.find(params[:id])
    respond_to do |format|
      if @blog_comment.update(blog_comment_params)
        format.html { redirect_to blog_post_url(@blog_post), notice: 'update successful' }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { redirect_to blog_post_url(@blog_post), notice: @blog_comment.errors.full_messages }
        format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_comments/1 or /blog_comments/1.json
  def destroy
    @blog_comment.destroy

    respond_to do |format|
      format.html { redirect_to blog_comment_url, notice: 'destroy successful' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_blog_comment
    @blog_comment = BlogComment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def blog_comment_params
    params.require(:blog_comment).permit(:body, :user_id, :blog_post_id, :parent_id)
  end
end
