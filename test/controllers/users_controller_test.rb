require "test_helper"

describe UsersController do

  describe "auth_callback" do
    it "logs in an existing user and redirects them to the root path" do
      expect {
        user = perform_login()
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      # You can test the flash notice too!
    end

    it "logs in a new user and redirects them back to the root path" do
      user = User.new(name: "Batman", provider: "github", uid: 999, email: "bat@man.com")
      OmniAuth.config.mock_auth[:github] = 
        OmniAuth::AuthHash.new(mock_auth_hash(user))

        expect {
          get auth_callback_path(:github)
        }.must_differ "User.count", 1

        user = User.find_by(uid: user.uid)
  
        must_redirect_to root_path
        expect(session[:user_id]).must_equal user.id
        # You can test the flash notice too!
    end

    it "should redirect back to root for invalid callbacks" do
      OmniAuth.config.mock_auth[:github] = 
      OmniAuth::AuthHash.new(mock_auth_hash(User.new))
      
      expect {
        get auth_callback_path(:github)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil


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
