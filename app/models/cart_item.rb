class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  def line_total
    product.price * quantity
  end
  # これで、CartItemオブジェクト.line_total とすると、メソッドを実行したカート内商品の合計金額を算出することができます。
end
