class Public::ColorsController < ApplicationController
  def index
    @colors = Color.all
  end
  
  def show
    @color = Color.find(params[:id])
    @posts = @color.posts
  end
end
