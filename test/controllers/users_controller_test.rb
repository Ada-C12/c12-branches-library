require "test_helper"

describe UsersController do

  describe "auth_callback" do
    it "logs in an existing user and redirects them to the root path" do
      user = users(:jared)

      OmniAuth.config.mock_auth[:github] = 
            OmniAuth::AuthHash.new(mock_auth_hash(user))

      expect {
        get auth_callback_path(:github)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id

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
