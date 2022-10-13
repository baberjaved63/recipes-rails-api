class Rating < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  validates :rate, numericality: { greater_than: 0, less_than_or_equal_to: 5, only_integer: true }
end
