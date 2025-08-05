class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:create, :elements]
  before_action :ensure_unpaid_order!, only: [:create, :elements]

  def create
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'inr',
          product_data: { name: "Order ##{@order.id}" },
          unit_amount: (@order.total * 100).to_i
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: payments_success_url + "?intent_id={CHECKOUT_PAYMENT_INTENT}",
      cancel_url: payments_cancel_url
    )

    create_payment(session.payment_intent)
    render json: { id: session.id }
  end

  def elements
    intent = Stripe::PaymentIntent.create(
      amount: (@order.total * 100).to_i,
      currency: "inr",
      payment_method: params[:payment_method_id],
      confirm: false
    )

    create_payment(intent.id)
    render json: { client_secret: intent.client_secret, intent_id: intent.id }
  end

  def success
    return redirect_to customer_dashboard_path, alert: "Invalid payment." if params[:intent_id].blank?

    intent = Stripe::PaymentIntent.retrieve(params[:intent_id])
    payment = Payment.find_by(stripe_payment_intent_id: intent.id)

    if payment&.order
      payment.update!(status: "paid")
      payment.order.update!(status: "confirmed")
      clear_cart(payment.order)

      @order = payment.order
      render :success

    else
      redirect_to customer_dashboard_path, alert: "Payment not found."
    end
  end

  def cancel
    @order = current_user.orders.order(created_at: :desc).first
    render :cancel
  end

  private

  def set_order
    @order = current_user.orders.find(params[:order_id])
  end

  def ensure_unpaid_order!
    return unless %w[confirmed delivered].include?(@order.status)

    render json: { error: "Order already paid." }, status: :unprocessable_entity
  end

  def create_payment(intent_id)
    Payment.create!(
      user: current_user,
      order: @order,
      stripe_payment_intent_id: intent_id,
      amount: @order.total,
      status: "pending"
    )
  end

  def clear_cart(order)
    Cart.find_by(user_id: order.user_id, restaurant_id: order.restaurant_id)&.cart_items&.destroy_all
  end
end
