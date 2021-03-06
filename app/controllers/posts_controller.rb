# Post class is responsible for creating posts
class PostsController < ApplicationController
    load_and_authorize_resource
    def index
        @posts = Post.all
    end

    def create
        @post =  Post.new(post_params)
        @post.save
        redirect_to @post
    end

    def show
        @post = Post.find(params[:id])
    end

    private
        def post_params
            params.require(:post).permit(:title, :text)
        end
end
