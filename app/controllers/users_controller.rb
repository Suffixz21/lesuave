class Users < ApplicationController
    before_action :find_user, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:index, :show]

    def index
        @user = User
    end

    def show
        @user = User.find(user_params)
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        @user.update(user_params)
    end

    private

    def find_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:id, :name, :summary, :birthday)
    end
end