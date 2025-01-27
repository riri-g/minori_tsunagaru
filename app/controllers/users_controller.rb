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
   
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu| 
        @userEntry.each do |u| 
          if cu.room_id == u.room_id 
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
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
    
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end


