class Public::PostsController < ApplicationController
  before_action :authenticate_user!

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
    tags = Vision.get_image_data(post_params[:image])
    @color = Color.find(params[:color_id])
    @post.user_id = current_user.id
    @post.color_id = @color.id
    if @post.save
      tags.each do |tag|
        @post.tags.create(name: tag)
      end
      flash[:notice] = "投稿しました"
      redirect_to post_path(@post.id)
    else
      @posts = Post.all
      @user = current_user
      render :index
    end
  end

  def edit
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
      flash[:notice] = "投稿の更新をしました"
    else
      render "edit"
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image, :profile_image)
  end
end
