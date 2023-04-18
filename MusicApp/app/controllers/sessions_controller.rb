class SessionsController < ApplicationController 

    def new
        @user = User.new

        render :new
    end

    def create 
        email = params[:user][:email]
        password = params[:user][:password]
        debugger
        @user = User.find_by_credentials(email,password)

        if @user
            login!(@user)
            # redirect_to user_url(@user)
        else
            @user = User.new(email: email)
            flash.now[:errors] = ["Invalid Credentials"]
            render :new 
        end
    end

    def destroy 
        if logged_in?
            logout!
            redirect_to new_user_url
        else
            flash[:messages] = ["Successfully logged out"]
            # redirect_to new_session_url 
        end
    end
end