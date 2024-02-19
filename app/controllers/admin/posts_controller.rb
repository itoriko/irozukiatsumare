class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to admin_posts_path(@post.id)
    else
      render :new
    end
  end

  def index
    @post = Post.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @item.update(post_params)
      redirect_to admin_posts_path(@post)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_posts_path, notice: "不適切な投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :user_id, :color_id, :image )
  end
end
