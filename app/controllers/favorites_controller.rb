class FavoritesController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    if !book.favorited_by?(current_user)
      @favorite = current_user.favorites.new(book_id: book.id)
      @favorite.save
      render 'replace_btn'
    end
  end

  def destroy
    book = Book.find(params[:book_id])
    if book.favorited_by?(current_user)
      @favorite = current_user.favorites.find_by(book_id: book.id)
      @favorite.destroy
      render 'replace_btn'
    end
  end
end
