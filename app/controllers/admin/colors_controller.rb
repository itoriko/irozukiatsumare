class Admin::ColorsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @colors = Color.all.page(params[:page]).per(10)
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)
    if @color.save
      flash[:notice] = "実装する色を追加しました。"
      redirect_to admin_colors_path
    else
      @colors = Color.all.page(params[:page]).per(10)
      flash.now[:alert] = "実装に失敗しました。"
      render :index
    end
  end

  def edit
    @color = Color.find(params[:id])
  end

  def update
    @color = Color.find(params[:id])
    if @color.update(color_params)
      redirect_to admin_colors_path, notice: "実装する色を変更しました。"
    else
      flash.now[:alert] = "変更に失敗しました。"
      render :edit
    end
  end

  def destroy
    color = Color.find(params[:id])
    color.destroy
    redirect_to admin_colors_path, notice: "実装する色を削除しました。"
  end

  private
  def color_params
    params.require(:color).permit(:name, :color_image)
  end
end
