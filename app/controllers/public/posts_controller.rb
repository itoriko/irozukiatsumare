class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_check, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    @color = Color.find(params[:color_id])
  end

  def show
    @newpost = Post.new
    @post = Post.find(params[:id])
    @posts = Post.all
    @user = @post.user
    @comment = Comment.new
  end

  def index
    @user = current_user
    @post = Post.new
    @posts = Post.where(color_id: params[:color_id]).page(params[:page]).per(10)
  end

  def create
    @post = Post.new(post_params)
    if post_params[:image].present?
      tags = Vision.get_image_data(post_params[:image])
    end
    @color = Color.find(params[:color_id])
    @post.user_id = current_user.id
    @post.color_id = @color.id
    if @post.save
      if post_params[:image].present?
        tags.each do |tag|
          @post.tags.create(name: tag)
        end
      end
      flash[:notice] = "投稿しました。"
      redirect_to post_path(@post.id)
    else
      @posts = Post.all
      @user = current_user
      flash[:alert] = "投稿に失敗しました。"
      render :index
    end
  end

  def edit; end

  def update
    if post_params[:image].present?
      tags = Vision.get_image_data(post_params[:image])
    end
    if @post.update(post_params)
      @post.tags.destroy_all
      if post_params[:image].present?
        tags.each do |tag|
          @post.tags.create(name: tag)
        end
      end
      redirect_to post_path(@post)
      flash[:notice] = "投稿の更新をしました。"
    else
      flash[:alert] = "投稿の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image, :profile_image)
  end

  def user_check
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: "不正な処理です。"
    end
  end
end
