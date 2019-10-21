class UsersController < ApplicationController

  # def login_form
  #   @user = User.new
  # end

  # def login
  #   username = params[:user][:username]

  #   found_user = User.find_by(username: username)

  #   if found_user
  #     # We DID find a user!
  #     session[:user_id] = found_user.id
  #     flash[:message] = "Logged in as returning user!"
  #   else
  #     # We did not find an existing user. Let's try to make one!
  #     new_user = User.new(username: username)
  #     new_user.save
  #     # TODO: What happens if saving fails?
  #     session[:user_id] = new_user.id
  #     flash[:message] = "Created a new user. Welcome!"
  #   end

  #   return redirect_to root_path
  # end

  # def logout
  #   # TODO: What happens if we were never logged in?
  #   session[:user_id] = nil
  #   flash[:message] = "You have logged out successfully."
  #   return redirect_to root_path
  # end

  def current
    @user = User.find_by(id: session[:user_id])
    if @user.nil?
      head :not_found
      return
    end 
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      # User was found in the database
      flash[:success] = "Logged in as returning user #{user.name}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
    user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid user instance
    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    
  end

end
