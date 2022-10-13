class Api::RecipesController < Api::BaseController
  # jitera-anchor-dont-touch: before_action_filter
  before_action :doorkeeper_authorize!, only: %w[index show update destroy]
  before_action :current_user_authenticate, only: %w[index show update destroy]
  before_action :get_recipe, only: %w[destroy update show]

  # jitera-anchor-dont-touch: actions
  def destroy
    @error_message = true unless @recipe&.destroy
  end

  def update
    request = {}
    request.merge!('title' => params.dig(:recipes, :title))
    request.merge!('descriptions' => params.dig(:recipes, :descriptions))
    request.merge!('time' => params.dig(:recipes, :time))
    request.merge!('difficulty' => params.dig(:recipes, :difficulty))
    request.merge!('category_id' => params.dig(:recipes, :category_id))
    request.merge!('user_id' => params.dig(:recipes, :user_id))

    @error_object = @recipe.errors.messages unless @recipe.update(request)
  end

  def show
    @error_message = true if @recipe.blank?
  end

  def create
    @recipe = Recipe.new

    request = {}
    request.merge!('title' => params.dig(:recipes, :title))
    request.merge!('descriptions' => params.dig(:recipes, :descriptions))
    request.merge!('time' => params.dig(:recipes, :time))
    request.merge!('difficulty' => params.dig(:recipes, :difficulty))
    request.merge!('category_id' => params.dig(:recipes, :category_id))
    request.merge!('user_id' => params.dig(:recipes, :user_id))

    @recipe.assign_attributes(request)
    @error_object = @recipe.errors.messages unless @recipe.save
  end

  def index
    request = {}

    request.merge!('title' => params.dig(:recipes, :title))
    request.merge!('descriptions' => params.dig(:recipes, :descriptions))
    request.merge!('time' => params.dig(:recipes, :time))
    request.merge!('difficulty' => params.dig(:recipes, :difficulty))
    request.merge!('category_id' => params.dig(:recipes, :category_id))
    request.merge!('user_id' => params.dig(:recipes, :user_id))

    @recipes = Recipe.search_for_index(params)
    @recipes = @recipes.includes(:ingredients, ratings: [:user])
  end

  private

  def get_recipe
    @recipe = Recipe.find(params[:id])
  end
end
