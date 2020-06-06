class CommentMailer < ApplicationMailer
  def created
    @comment = params[:comment]
    @user = params[:user]
    @ticket = @comment.ticket
    @project = @ticket.project

    subject = "[Ticketee] #{@project.name} - #{@ticket.name}"
    mail(to: @user.email, subject: subject)
  end
end
