class Api::IngredientsController < Api::BaseController
  before_action :get_ingredient, only: %w[destroy update show]
  # jitera-anchor-dont-touch: before_action_filter

  # jitera-anchor-dont-touch: actions
  def destroy
    @error_message = true unless @ingredient&.destroy
  end

  def update
    request = {}
    request.merge!('unit' => params.dig(:ingredients, :unit))
    request.merge!('amount' => params.dig(:ingredients, :amount))
    request.merge!('recipe_id' => params.dig(:ingredients, :recipe_id))

    @error_object = @ingredient.errors.messages unless @ingredient.update(request)
  end

  def show
    @error_message = true if @ingredient.blank?
  end

  def create
    @ingredient = Ingredient.new

    request = {}
    request.merge!('unit' => params.dig(:ingredients, :unit))
    request.merge!('amount' => params.dig(:ingredients, :amount))
    request.merge!('recipe_id' => params.dig(:ingredients, :recipe_id))

    @ingredient.assign_attributes(request)
    @error_object = @ingredient.errors.messages unless @ingredient.save
  end

  def index
    request = {}

    request.merge!('unit' => params.dig(:ingredients, :unit))
    request.merge!('amount' => params.dig(:ingredients, :amount))
    request.merge!('recipe_id' => params.dig(:ingredients, :recipe_id))

    @ingredients = Ingredient.all
  end

  private

  def get_ingredient
    @ingredient = Ingredient.find(params[:id])
  end
end
