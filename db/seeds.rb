require 'faker'
require 'securerandom'

puts "🌱 Seeding 50 Restaurants and Menu Items..."

MenuItem.destroy_all
Restaurant.destroy_all

owner = User.find_by(email: "dheerajkalwar866@gmail.com")

if owner.nil?
  puts "⚠️  User not found. Please create the user before running the seed."
  exit
end

# Make sure DishCategory exists
if DishCategory.count.zero?
  %w[Starter Main Dessert Beverage].each do |cat|
    DishCategory.create!(name: cat)
  end
  puts "📦 Seeded Dish Categories"
end

DISH_CATEGORIES = DishCategory.all.to_a

def random_image_url(width, height)
  "https://picsum.photos/#{width}/#{height}?random=#{rand(1000..9999)}"
end

FOOD_IMAGES = [
  "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1543352634-5077b4a3ee8d?auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1514516870925-45b50f09f746?auto=format&fit=crop&w=300&q=80",
  "https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=300&q=80"
]

def food_image_url
  FOOD_IMAGES.sample
end

50.times do |i|
  restaurant = Restaurant.create!(
    name: Faker::Restaurant.unique.name,
    description: Faker::Restaurant.description,
    location: Faker::Address.full_address,
    image_url: random_image_url(600, 400),
    user: owner
  )

  rand(3..6).times do
    restaurant.menu_items.create!(
      name: Faker::Food.dish,
      description: Faker::Food.description,
      price: rand(100..500),
      image_url: food_image_url,
      dish_category: DISH_CATEGORIES.sample
    )
  end

  puts "✅ Created restaurant #{i + 1}: #{restaurant.name}"
end

puts "🎉 Done! 50 Restaurants with menu items and categories created."
