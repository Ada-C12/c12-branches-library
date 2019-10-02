require "test_helper"

describe BooksController do
  
  describe "index action" do

    it "gives back a successful response" do

      # Arrange
      # ... Nothing right now!

      # Act
      # Send a specific request... a GET request to the path "/books"
      # get "/books"
      get books_path

      # Assert
      # The response was OK!
      must_respond_with :success
      # must_respond_with 200
      # must_respond_with :redirect
      # must_respond_with :missing
      # must_respond_with :error

    end

    it "gives back a 404 if there are no books available" do

      # Arrange
      # Insert some code here that destroys all of the books in the database...

      # Act
      # get "/books"
      get books_path

      # Assert
      # must_respond_with :missing
    end

  end

  describe 'show action' do

    it 'responds with a success when id given exists' do
      valid_book = Book.create(title: "Valid Book")
      
      # get "/books/#{valid_book.id}"
      get book_path(valid_book.id)

      must_respond_with :success

    end

    it 'responds with a not_found when id given does not exist' do
      get book_path("500")

      must_respond_with :not_found
    end



  end

  describe 'create action' do

    it 'creates a new book successfully with valid data, and redirects the user to the book page' do
      # Arrange
      # Even though in our Controller code, Rails sets up the form data and params...
      # ...in the tests, we need to arrange and set this up
      # For each test that will have form data, we need to add something that looks like the form data in params...
      book_hash = {
        book: {
          title: "Practical Object Oriented Programming in Ruby",
          author: "Sandi Metz",
          description: 'A look at how to design object-oriented systems'
        }
      }

      # Act-Assert
      expect {
        # Don't forget to send the form data hash we just built for this test into params here.
        post books_path, params: book_hash
      }.must_differ 'Book.count', 1

      must_redirect_to book_path(Book.find_by(title: "Practical Object Oriented Programming in Ruby"))
    end

  end

  describe 'update action' do

    it "updates an existing book successfully and redirects to home" do

      # Optional check: check to make sure that at least one Book exists
      # Pseudocode: expect that Book.count is greater than 0

      # Arrange
      # Find an existing book and its id
      # Set up the form data to what the book will be updated to...

      existing_book = Book.first
      updated_book_form_data = {
        book: {
          title: "Practical Object Oriented Programming in Ruby",
          author: "Sandi Metz",
          description: 'A look at how to design object-oriented systems'
        }
      }

      # Act
      # Update the book data, don't forget to send the updated_book_form_data in params here

      # Assert
      # expect( Book.find_by(id: existing_book.id).title ).must_equal "Practical Object Oriented Programming in Ruby"

    end

  end



end
