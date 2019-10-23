ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/autorun'
require 'minitest/reporters'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    return {
      provider: user.provider,
      uid: user.uid,
      info: {
        email: user.email,
        nickname: user.name
        # You can add more fields from
        # The omniauth hash here
      }
    }
  end

  def perform_login(user = User.first)
    
    OmniAuth.config.mock_auth[:github] = 
        OmniAuth::AuthHash.new(mock_auth_hash(user))

    get auth_callback_path(:github)

    return user
  end
end
