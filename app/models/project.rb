class Project < ApplicationRecord
  has_many :tickets, dependent: :delete_all
  validates :name, presence: true
end
