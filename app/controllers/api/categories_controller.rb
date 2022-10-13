class Api::CategoriesController < Api::BaseController
  before_action :get_category, only: %w[destroy update show]
  # jitera-anchor-dont-touch: before_action_filter

  # jitera-anchor-dont-touch: actions
  def destroy
    @error_message = true unless @category&.destroy
  end

  def update
    request = {}
    request.merge!('description' => params.dig(:categories, :description))

    @error_object = @category.errors.messages unless @category.update(request)
  end

  def show
    @error_message = true if @category.blank?
  end

  def create
    @category = Category.new

    request = {}
    request.merge!('description' => params.dig(:categories, :description))

    @category.assign_attributes(request)
    @error_object = @category.errors.messages unless @category.save
  end

  def index
    request = {}
    request.merge!('description' => params.dig(:categories, :description))

    @categories = Category.all
  end

  private

  def get_category
    @category = Category.find(params[:id])
  end
end
