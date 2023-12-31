# frozen_string_literal: true

class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_blog_post, only: %i[show edit update destroy]
  authorize_resource except: %i[index show]
  include Pagy::Backend

  # GET /blog_posts or /blog_posts.json
  def index
    @blog_posts = BlogPost.order('created_at desc')
    @pagy, @records = pagy(@blog_posts)
    Rails.logger.info("parameters: #{params}")

    render :index, locals: { blog_posts: @blog_posts, records: @records, pagy: @pagy }
  end

  # GET /blog_posts/1 or /blog_posts/1.json
  def show
    render :show, locals: { blog_post: @blog_post, user: @user }
  end

  # GET /blog_posts/new
  def new
    @blog_post = BlogPost.new

    render :new, locals: { blog_post: @blog_post, user: current_user }
  end

  # GET /blog_posts/1/edit
  def edit
    render :edit, locals: { blog_post: @blog_post, user: @user }
  end

  # POST /blog_posts or /blog_posts.json
  def create
    @blog_post = BlogPost.new(blog_post_params)

    respond_to do |format|
      if @blog_post.save
        create_success(format, @blog_post)
      else
        create_error(format, @blog_post, current_user)
      end
    end
  end

  # PATCH/PUT /blog_posts/1 or /blog_posts/1.json
  def update
    respond_to do |format|
      if @blog_post.update(blog_post_params)
        update_success(format, @blog_post)
      else
        update_error(format, @blog_post, @user)
      end
    end
  end

  # DELETE /blog_posts/1 or /blog_posts/1.json
  def destroy
    @blog_post.destroy

    respond_to do |format|
      format.html { redirect_to blog_posts_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def blog_post_params
    params.require(:blog_post).permit(:title, :body, :user_id)
  end

  def create_success(format, blog_post)
    format.html { redirect_to blog_post_url(blog_post), notice: t('.success') }
    format.json { render :show, status: :created, location: blog_post }
  end

  def create_error(format, blog_post, user)
    format.html { render :new, status: :unprocessable_entity, locals: { blog_post:, user: } }
    format.json { render json: blog_post.errors, status: :unprocessable_entity }
  end

  def update_success(format, blog_post)
    format.html { redirect_to blog_post_url(blog_post), notice: t('.success') }
    format.json { render :show, status: :ok, location: blog_post }
  end

  def update_error(format, blog_post, user)
    format.html { render :edit, status: :unprocessable_entity, locals: { blog_post:, user: } }
    format.json { render json: @blog_post.errors, status: :unprocessable_entity }
  end
end
