require 'faker'
require 'securerandom'

puts "🌱 Seeding 50 Restaurants and Menu Items..."

MenuItem.destroy_all
Restaurant.destroy_all
DishCategory.destroy_all
DeliveryBoy.destroy_all
Order.destroy_all
OrderItem.destroy_all

owner = User.find_by(email: "dheerajkalwar866@gmail.com")

if owner.nil?
  puts "⚠️  User not found. Please create the user before running the seed."
  exit
end

# Create Dish Categories if not already present
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

# Create 50 restaurants
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

# ✅ Create 10 delivery boys and save them in an array
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

# ✅ Create one order and assign one of the delivery boys
puts "🛒 Creating one Order..."

restaurant = Restaurant.first
user = owner
delivery_boy = delivery_boys.sample  # Pick a random delivery boy from the array

if user && restaurant && delivery_boy
  order = Order.create!(
    user: user,
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
