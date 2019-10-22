class BooksController < ApplicationController

  before_action :find_book, only: [:show, :edit, :update]

  # Can now be accessed via /, /books, or /authors/:author_id/books
  def index
    author_id = params[:author_id]
    # If not coming from /authors/:author_id/books
    if author_id.nil?
      @books = Book.all
    else
      @author = Author.find_by(id: author_id)
      if @author
        @books = @author.books
      # We couldn't find the given author_id in the database
      else
        head :not_found
      end
    end
  end

  def show
    if @book.nil?
      head :not_found
      return
    end
  end

  def new
    author_id = params[:author_id]
    @book = Book.new
    @authors = Author.all
    if author_id
      @authors = [Author.find_by(id: author_id)]
    end
  end

  def create
    @book = Book.new( book_params )
    @authors = Author.all

    if @book.save
      # If the book saves correctly, we will notify the user that it was good using flash, and then redirect them to the book show page
      flash[:success] = "Book #{@book.id} added successfully"
      redirect_to book_path(@book.id)
    else
      flash.now[:error] = "You didn't do it right."
      render new_book_path
    end
  end

  def edit
    @authors = Author.all
  end

  def update
    # Instead of doing @book.title = ... assignment, and then @book.save, we will instead do "if @book.update( book_params )" to use strong params pattern. @book.update() will be false if the update was unsuccessful
    if @book.update( book_params )
      redirect_to book_path(@book.id)
    else
      render new_book_path
    end
  end

  def destroy
    # We will find the right book using the id found in params
    # Then, depending on if we find it...
    #   we will either destroy it, then we will redirect to root page
    #   or not! and we will redirect to index page

    the_correct_book = Book.find_by( id: params[:id] )

    # Because find_by will give back nil if the book is not found...

    if the_correct_book.nil?
      # Then the book was not found!
      redirect_to books_path
      return
    else
      # Then we did find it!
      the_correct_book.destroy
      flash[:success] = "Your book " + the_correct_book.title + " was successfully deleted!"
      redirect_to root_path
      return
    end
  end

  private

  def find_book
    @book = Book.find_by(id: params[:id])
  end

  # Every method defined under the word private is going to be a private method

  def book_params
    # The responsibility of this method is to return "strong params"
    # .require is used when we use form_with and a model, and therefore our expected form data has the "book" hash inside of it
    # .permit takes in a list of names of attributes to allow... (aka the new Book form has title, author, description)
    return params.require(:book).permit(:title, :author_id, :description, genre_ids: [])

    # Remember: If you ever update the database, model, and form, this will also need to be updated
  end

end
