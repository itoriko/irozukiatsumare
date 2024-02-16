class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit,:update]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @user = current_user
    @users = User.page(params[:page])
    @post = Post.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save
    redirect_to users_index_path
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @posts = @user.posts.page(params[:page])
    @comment = Comment.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "情報を更新しました！"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def unsubscribe
    @user = current_user
  end

  def withdraw
    @user = current_user
    @user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: "今までのご利用、誠に有難う御座いました。"
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :user_name_kana, :introduction, :birth_date, :occupation, :email, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
