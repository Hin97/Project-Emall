class CategoriesController < ApplicationController
  def new
  @category = Category.new
  end

  def show
  @category = Category.find(params[:id])
  @item = Item.all
  end
  
    private

    def category_params
      params.require(:category).permit(:name)
    end
end
