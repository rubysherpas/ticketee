class CommentNotifier
  attr_reader :comment

  def initialize(comment)
    @comment = comment
  end

  def notify_watchers
    comment.ticket.watchers.without(comment.author).each do |user|
      CommentMailer
        .with(comment: comment, user: user)
        .created
        .deliver_later
    end
  end
end
