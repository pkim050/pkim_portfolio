# frozen_string_literal: true

class BlogCommentsController < ApplicationController
  def new
    @blog_post = BlogPost.find(params[:post_id])
    @blog_comment = @blog_post.blog_comments.new(parent_id: params[:parent_id])
  end

  # POST /blog_comments or /blog_comments.json
  def create
    @blog_post = BlogPost.find(params[:id])
    @blog_comment = @blog_post.blog_comments.new(blog_comment_params)

    respond_to do |format|
      if @blog_comment.save
        format.html { redirect_to @blog_post, notice: 'Comment was successfully created.' } # changed the redirect to @post
        format.json { render :show, status: :created, location: @blog_post }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /blog_comments/1/edit
  def edit; end

  # PATCH/PUT /blog_comments/1 or /blog_comments/1.json
  def update
    @blog_post = BlogPost.find(params[:id])
    respond_to do |format|
      if @blog_comment.update(blog_comment_params)
        format.html { redirect_to blog_post_url(@blog_post), notice: 'update successful' }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { render :show, status: :unprocessable_entity }
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
