class Message < ApplicationRecord
  MAX_FILE_SIZE_MB  = 10
  MAX_USER_MESSAGES = 10

  has_one_attached :file

  belongs_to :chat

  validates :content, length: { minimum: 10, maximum: 1000 }, if: -> { role == "user" }

  validate :file_size_limit
  validate :user_message_limit, if: -> { role == "user" }

  after_create_commit :broadcast_append_to_chat

  private

  def broadcast_append_to_chat
    broadcast_append_to chat, target: "messages", partial: "messages/message", locals: { message: self }
  end

  def file_size_limit
    if file.attached? && file.byte_size > MAX_FILE_SIZE_MB.megabytes
      errors.add(:file, "size must be less than #{MAX_FILE_SIZE_MB}MB")
    end
  end

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
    end
  end
end
