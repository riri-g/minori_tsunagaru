class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:message][:room_id])
    @message = Message.new(message_params.merge(user_id: current_user.id))

    # メッセージ送信処理
    if Entry.exists?(user_id: current_user.id, room_id: @room.id)
      if @message.save
        Rails.logger.info("Message saved: #{@message.content}")  # 保存されたメッセージ内容をログに出力
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @room }  # 非同期が動かない場合のフォールバック
        end
      else
        @messages = @room.messages.includes(:user)
        @entries = @room.entries
        @another_entry = @entries.where.not(user_id: current_user.id).first

        respond_to do |format|
          format.turbo_stream
          format.html do
            flash.now[:alert] = @message.errors.full_messages.join(", ")
            render 'rooms/show', status: :unprocessable_entity
          end
        end
      end
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
      redirect_to rooms_path
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @message = @room.messages.find(params[:id])

    if @message.user_id == current_user.id
      @message.destroy
      redirect_to room_path(@room), notice: "メッセージを削除しました。"
    else
      redirect_to room_path(@room), alert: "他人のメッセージは削除できません。"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
