class Challenge < ApplicationRecord
  has_many :chats, dependent: :destroy

  validates :name, :module, :content, presence: true
end
