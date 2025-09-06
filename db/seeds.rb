require 'faker'
require 'securerandom'

puts "🌱 Seeding User, Restaurants, and Menu Items..."

# ✅ Create or find the owner user
owner = User.find_or_create_by!(email: "dheerajkalwar866@gmail.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = "customer"
  # user.confirmed_at = Time.now  # Uncomment if using Devise with confirmable
end

puts "👤 User ensured: #{owner.email}"

# ✅ Destroy all existing records (order matters due to dependencies)
OrderItem.destroy_all
Order.destroy_all
DeliveryBoy.destroy_all
MenuItem.destroy_all
Restaurant.destroy_all
DishCategory.destroy_all

# ✅ Create Dish Categories if not already present
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

# ✅ Create 50 restaurants and menu items
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

# ✅ Create 10 delivery boys
puts "🚴 Creating 10 Delivery Boys..."

delivery_boys = Array.new(10) do
  DeliveryBoy.create!(
    name: Faker::Name.name,
    phone: Faker::PhoneNumber.unique.cell_phone_in_e164,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    available: true
  )
end

puts "✅ 10 Delivery Boys created."

# ✅ Create one sample order
puts "🛒 Creating one Order..."

restaurant = Restaurant.first
delivery_boy = delivery_boys.sample

if owner && restaurant && delivery_boy
  order = Order.create!(
    user: owner,
    restaurant: restaurant,
    delivery_address: "Connaught Place, New Delhi",
    latitude: 28.6315,
    longitude: 77.2167,
    status: "out_for_delivery",
    delivery_boy: delivery_boy
  )

  puts "✅ Order ##{order.id} created and assigned to #{delivery_boy.name}"
else
  puts "⚠️  User, Restaurant, or DeliveryBoy missing — Order not created"
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?