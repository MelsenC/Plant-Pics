class PicsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
    @pic = Pic.new
  end

  def create
    @pic = current_user.pics.create(pic_params)
    if @pic.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def pic_params
    params.require(:pic).permit(:message)
  end

end
