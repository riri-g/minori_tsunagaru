class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:message][:room_id])
    @message = Message.new(message_params.merge(user_id: current_user.id))
    
    if Entry.exists?(user_id: current_user.id, room_id: @room.id)
      if @message.save
        redirect_to @room
      else
        @messages = @room.messages.includes(:user)
        @entries = @room.entries
        @another_entry = @entries.where.not(user_id: current_user.id).first
  
        flash.now[:alert] = @message.errors.full_messages.join(", ")
        render 'rooms/show', status: :unprocessable_entity
      end
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
      redirect_to rooms_path
    end
  end
  
private

  def message_params
    params.require(:message).permit(:user_id, :room_id, :content)
  end


end