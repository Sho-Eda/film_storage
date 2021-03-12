class PostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :corrent_user, only: [:destroy]

  def index
    @posts = current_user.posts.order(id: :desc).page(params[:page]).per(3)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.page(params[:page]).per(3)
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = '投稿しました。'
      redirect_to current_user
    else
      @posts = current_user.feed_posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      redirect_to current_user
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '削除しました。'
    redirect_to current_user
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])

    if @post.update(post_params)
      flash[:success] = '更新しました'
      redirect_to @post

    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end




  private

  def post_params
    params.require(:post).permit(:content, :image, :title, :name, category_ids: [])
  end

  def corrent_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to current_user unless @post
  end

end
