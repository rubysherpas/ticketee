class Project < ApplicationRecord
  validates :name, presence: true

  has_many :tickets, dependent: :delete_all
end
