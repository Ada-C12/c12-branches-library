require "test_helper"

describe UsersController do

  describe "auth_callback" do
    it "redirects to root and logs user in when user exists" do
      starting_size = User.count
      # retrieve existing user
      user = users(:grace)
      perform_login(user)
      # assert session
      session[:user_id].must_equal user.id
      # assert redirect
      must_redirect_to root_path
      # assert users table didn't change
      User.count.must_equal starting_size
    end

    it "redirects to root and creates new logged in user when user doesn't exist" do
      # Create new user (don't save to db yet)
      starting_size = User.count
      user = User.new(name: "Jared", email: "j@thatsme.com", uid: 1234, provider: "github")
      perform_login(user)
      # assert session
      session[:user_id].must_equal User.last.id
      # assert redirect
      must_redirect_to root_path
      # asser users table has one new row
      User.count.must_equal starting_size + 1
    end

    it "redirects to root with no user logged in and displays flash message with user data is invalid" do
      starting_size = User.count
      user = User.new
      perform_login(user)
      session[:user_id].must_equal nil
      flash[:error].must_include "Could not create new user account:"
      must_redirect_to root_path
      User.count.must_equal starting_size
    end
  end

  describe "current" do

    it "responds with success when user has logged in" do
      # Arrange
      perform_login

      # Act
      get current_user_path

      # Assert
      must_respond_with :success
    end

    it "responds with not_found when user hasn't logged in" do
      # No arrange needed

      # Act
      get current_user_path

      # Assert
      must_respond_with :not_found
    end
    
  end
end
