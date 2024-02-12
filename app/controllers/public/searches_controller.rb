class Public::SearchesController < ApplicationController
    before_action :authenticate_user!

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

  end

end
