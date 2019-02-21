class ProductsController < ApplicationController
    def index
        @products = Products
    end

    def show
        @product = Products.find(product_params)
    end

    def edit
        @product = Products.find(params[:id])
    end

    def create
        @product =  Products.new(product_params)
        @product.save
        redirect_to @product
    end

    private
        def product_params
            params.require(:product).permit(:name, :price)
        end
end
