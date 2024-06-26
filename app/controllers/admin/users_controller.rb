class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admin_users_path, notice: "情報を更新しました。"
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path, notice: "不適切なユーザーを削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(:image, :user_name, :user_name_kana, :occupation, :introduction, :email, :is_active, :profile_image)
  end
end
