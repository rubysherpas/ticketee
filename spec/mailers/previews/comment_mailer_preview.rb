class CommentMailerPreview < ActionMailer::Preview
  def new_comment
    project = Project.new(id: 1, name: "Example Project")
    ticket = project.tickets.build(id: 1, name: "Example Ticket")
    user = User.new(email: "user@ticketee.com")
    comment = ticket.comments.build(author: user, text: "Hello there")

    CommentMailer.with(comment: comment, user: comment.author).new_comment
  end
end
