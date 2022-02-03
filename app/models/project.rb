class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
end
