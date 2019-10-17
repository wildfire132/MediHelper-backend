class UsersController < ApplicationController

    def index
        @users = User.all
        render :json => @users
    end

    def create
        @user = User.find_by(username: params["userData"]["id"])
        if @user == nil 
            @my_user = User.new(name: params["userData"]["name"], username: params["userData"]["id"], img_url: params["userData"]["picture"]["data"]["url"], email:params["userData"]["email"])
            @my_user.save
        else 
            @my_user = @user
        end

        render :json => @my_user
    end

end
