class CategoriesController < ApplicationController
  def new
  @category = Category.new
  end

  def show
  @category = Category.find(params[:id])
  @item = Item.all
  @count = false
  end
  
    private

    def category_params
      params.require(:category).permit(:name)
    end
end
