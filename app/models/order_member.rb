class OrderMember < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  PAYMENT_TYPES = ["Check", "Credit card", "Purchase order" ]
  validates :name, :note, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES

  def add_order_items_from_cart(cart)
    cart.order_items.each do |item|
      item.cart_id = nil
      order_items << item
    end
  end
end
