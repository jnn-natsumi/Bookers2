class BooksController < ApplicationController
	before_action :authenticate_user!
	before_action :correct_book, only: [:edit, :update]

	def create
		@book = Book.new(book_params)
		@book.user_id = current_user.id
		if @book.save
			flash[:notice] = "You have created book successfully."
		    redirect_to book_path(@book)
		    # １からコントローラーをまわす
		else
			@user = current_user
			@books = Book.all
			render :index
			# viewだけをもってくる（１から読み込まない）
			# エラーが出なくなる
		end
	end

	def index
		@user = current_user
		@book = Book.new
		@books = Book.all
	end

	def show
		@bbook = Book.new
		@book = Book.find(params[:id])
		@user = User.find_by(id: @book.user_id)
		# rails find by（findとの違い）で検索
	end

        # コントローラのルーティングを設定します。
	def edit
        @book = Book.find(params[:id])
	end

	def update
		@book = Book.find(params[:id])
		if @book.update(book_params)
		   flash[:notice] = "You have updated book successfully"
		   redirect_to book_path(@book.id)
		else
			render action: :edit
		end
	end

	def destroy
		@book = Book.find(params[:id])
		@book.destroy
		redirect_to books_path
	end

	def correct_book
        @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
    end

	private
	def book_params
		params.require(:book).permit(:title, :body)
	end
end
