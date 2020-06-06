# Preview all emails at http://localhost:3000/rails/mailers/comment_mailer
class CommentMailerPreview < ActionMailer::Preview
  def created
    comment = Comment.first

    CommentMailer.with(comment: comment, user: comment.author).created
  end
end
