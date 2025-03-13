class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.create
    @current_entry = @room.entries.create(user_id: current_user.id)
    @another_entry = @room.entries.create(user_id: params[:entry][:user_id])
    redirect_to room_path(@room)
  end

  def index
    my_room_id = current_user.entries.pluck(:room_id)
    @another_entries = Entry
                       .where(room_id: my_room_id)
                       .where.not(user_id: current_user.id)
                       .preload(room: :messages)
  end

  def show
    @room = Room.find(params[:id])
    if @room.entries.where(user_id: current_user.id).present?
      @messages = @room.messages.all
      @message = Message.new
      @entries = @room.entries
      @another_entry = @entries.where.not(user_id: current_user.id).first
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy_message
    @room = Room.find(params[:room_id])
    @message = @room.messages.find(params[:id])

    if @message.user_id == current_user.id
      @message.destroy
      respond_to do |format|
        format.turbo_stream  # Turbo Streamでリアルタイムに削除を反映
        format.html { redirect_to @room, notice: "メッセージを削除しました。" }
      end
    else
      redirect_to @room, alert: "他人のメッセージは削除できません。"
    end
  end
end