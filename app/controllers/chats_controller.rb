class ChatsController < ApplicationController
  def create
    @challenge = Challenge.find(params[:challenge_id])

    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.challenge = @challenge
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @challenge.chats.where(user: current_user)
      render "challenges/show"
    end
  end

  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
  end
end
