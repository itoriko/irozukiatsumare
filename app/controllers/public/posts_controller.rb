class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
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
    @posts = Post.page(params[:page])
    if params[:word]
      @posts = @posts.where('name like ? ', '%'+params[:word]+'%')
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました！"
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
      flash[:notice] = "投稿の更新をしました！"
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
    params.require(:post).permit(:title, :content, :image)
  end
end
