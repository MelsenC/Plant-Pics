class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @pic = Pic.find_by_id(params[:pic_id])
    return render_not_found if @pic.blank?
    @pic.comments.create(comment_params.merge(user: current_user))
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end
