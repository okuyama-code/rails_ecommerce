module Customer::CartItemsHelper
  # cart_items という配列を引数にとり、sum メソッドで quantity の合計値を算出しています。app/views/layouts/application.html.erbでカートのアイコンを表示する際に使用する
  def total_quantity(cart_items)
    cart_items.sum(:quantity)
  end
end
