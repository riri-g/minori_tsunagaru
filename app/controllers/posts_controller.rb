class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    # 公開された投稿またはログインユーザーの投稿を取得
    @posts = Post.where("status = ? OR user_id = ?", Post.statuses[:published], current_user.id)
  
    # カテゴリーリストを取得
    @categories = Category.all
  
    # 投稿を最新順で取得
    @posts = @posts.order(created_at: :desc)
  
    # 検索キーワードによるフィルタリング
    if params[:search].present?
      @posts = @posts.where('location LIKE ?', "%#{params[:search]}%")
    end
  
    # カテゴリーによるフィルタリング
    if params[:category_id].present?
      @posts = @posts.where(category_id: params[:category_id])
    end
  
    # ページネーションを適用
    @posts = @posts.page(params[:page]).per(10)
  end
  
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end
 
  def confirm
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
  end

  def search_by_category
    if params[:category_id].present?
      @posts = Post.where(category_id: params[:category_id]).order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
  
    @categories = Category.all # フォーム用
    render :index # 検索結果を投稿一覧ページに表示
  end

  
  
  
  private
  def post_params
    params.require(:post).permit(:user_id, :location, :address, :text, :image, :status, :category_id)
  end

end
