class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :menu_items, dependent: :destroy
  has_many :reviews, dependent: :destroy


  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "%#{query.downcase}%") if query.present?
  }

  scope :filter_by_location, ->(location) {
    where("LOWER(location) LIKE ?", "%#{location.downcase}%") if location.present?
  }

  scope :filter_by_category, ->(category_id) {
    joins(:menu_items).where(menu_items: { dish_category_id: category_id }) if category_id.present?
  }

  scope :filter_by_price_range, ->(min_price, max_price) {
    joins(:menu_items).where(menu_items: { price: min_price..max_price }) if min_price.present? && max_price.present?
  }

  def self.filtered(params)
    search_by_name(params[:search])
      .filter_by_location(params[:location])
      .filter_by_category(params[:category])
      .filter_by_price_range(params[:min_price], params[:max_price])
      .distinct
  end

  def average_rating
    reviews.average(:rating)&.round(1) || 0.0
  end
end



