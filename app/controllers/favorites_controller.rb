class FavoritesController < ApplicationController

  def create
    @id = params[:post_id]
    @post = Micropost.find(params[:post_id])
    current_user.favorite(@post)
  end

  def destroy
    @id = params[:post_id]
    @post = current_user.favorite_posts.find_by(post_id: params[:post_id]).post
    current_user.unfavorite(@post)
  end



end
