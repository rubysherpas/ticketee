class CommentsController < ApplicationController
  before_action :set_ticket

  def create
    @comment = @ticket.comments.build(comment_params)
    @comment.author = current_user

    if @comment.save
      comment_notifier = CommentNotifier.new(@comment)
      comment_notifier.notify_watchers
      unless @ticket.watchers.exists?(current_user.id)
        @ticket.watchers << current_user
      end
      flash[:notice] = "Comment has been created."
      redirect_to [@ticket.project, @ticket]
    else
      flash.now[:alert] = "Comment has not been created."
      @states = State.all
      @project = @ticket.project
      render "tickets/show"
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def comment_params
    params.require(:comment).permit(:text, :state_id)
  end
end
