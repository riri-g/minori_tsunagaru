class UsersController < ApplicationController
  before_action :authenticate_user!
   
  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8).reverse_order
    @published_posts = @user.posts.published.page(params[:page]).per(8).reverse_order
     # 下書き投稿は、自分のものだけ取得
    if @user == current_user
      @draft_posts = @user.posts.draft.page(params[:page]).per(8).reverse_order
    else
      @draft_posts = Post.none # 他のユーザーの下書きは取得しない
    end
    
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  
    if @user != current_user
      @room = current_user.rooms.joins(:entries).find_by(entries: { user_id: @user.id })
      unless @room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end
  
  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end
  
  def create
    @room = Room.create
    @current_entry = @room.entries.create(user_id: current_user.id)
    @another_entry = @room.entries.create(user_id: params[:entry][:user_id])
    redirect_to room_path(@room)
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end


