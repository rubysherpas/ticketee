class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :author, class_name: "User"
  belongs_to :state, optional: true

  after_create :set_ticket_state

  validates :text, presence: true

  scope :persisted, -> { where.not(id: nil) }
  scope :ordered, -> { order(created_at: :asc) }

  private

  def set_ticket_state
    ticket.state = state
    ticket.save!
  end
end
