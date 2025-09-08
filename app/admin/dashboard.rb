ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "🏠 Dashboard"

  content title: "Admin Dashboard" do

    # ✅ Simple Stat Cards
    columns do
      column do
        panel "👥 Total Users" do
          h3 User.count
        end
      end

      column do
        panel "🍽 Total Restaurants" do
          h3 Restaurant.count
        end
      end

      column do
        panel "📦 Total Orders" do
          h3 Order.count
        end
      end
    end

    # 📈 Simple Chart: User Signups
    panel "📈 User Signups (Last 7 Days)" do
      line_chart User.group_by_day(:created_at, last: 7).count
    end

    # 🆕 Recent Orders
    panel "🛒 Recent Orders" do
      table_for Order.order(created_at: :desc).limit(5) do
        column("Order ID") { |order| link_to order.id, admin_order_path(order) }
        column("Status")   { |order| order.status }
        column("User")     { |order| order.user&.email || "N/A" }
        column("Date")     { |order| order.created_at.strftime("%b %d, %Y") }
      end
    end

  end
end
