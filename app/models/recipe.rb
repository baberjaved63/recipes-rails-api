class Recipe < ApplicationRecord
  searchkick

  include ConstantValidatable

  # jitera-anchor-dont-touch: relations

  belongs_to :category
  belongs_to :user

  has_many :ingredients, dependent: :destroy
  has_many :ratings
  has_many :reviewers, through: :ratings, source: 'user'

  # jitera-anchor-dont-touch: enum
  enum difficulty: %w[easy normal challenging], _suffix: true

  # jitera-anchor-dont-touch: file

  # jitera-anchor-dont-touch: validation

  validates :title, length: { maximum: 255, minimum: 0, message: I18n.t('.out_of_range_error') }, presence: true
  validates :descriptions, length: { maximum: 65_535, minimum: 0, message: I18n.t('.out_of_range_error') },
                           presence: true
  validates :time, length: { maximum: 255, minimum: 0, message: I18n.t('.out_of_range_error') }, presence: true
  validates :difficulty, presence: true

  accepts_nested_attributes_for :ingredients

  def self.associations
    [:ingredients]
  end

  def self.search_for_index(params)
    return self.all unless params[:query].present? || params[:filter].present?

    if params[:query].present?
      search(params[:query], fields: [:title], match: :word_middle)
    else
      search_through_filters(params)
    end
  end

  def self.search_through_filters(params)
    if params[:filter][:difficulty].present?
      search(where: { difficulty: params[:filter][:difficulty] })
    else
      search(where: { time: params[:filter][:start]..params[:filter][:end] })
    end
  end

  # jitera-anchor-dont-touch: reset_password

  class << self
  end
end
