class Customer::ProductsController < ApplicationController
  def index
    @products, @sort = get_products(params)
  end

  def show
    @product = Product.find(params[:id])
    # 商品をカートに追加できるよう、空の CartItem モデルを定義する
    @cart_item = CartItem.new
  end

  private

  def get_products(params)
    return Product.all, 'default' unless params[:latest] || params[:price_high_to_low] || params[:price_low_to_high]

    return Product.latest, 'latest' if params[:latest]

    # 商品の価格を高いものから低いものへと並べ替える機能
    return Product.price_high_to_low, 'price_high_to_low' if params[:price_high_to_low]

    [Product.price_low_to_high, 'price_low_to_high'] if params[:price_low_to_high]
  end
end

# 例えば、http://localhost:8000/products?latest=true という URL にアクセスした場合、params[:latest] が true となりますので、get_products メソッド内の二つ目の条件に合致します。すると、Product.latest が実行され、作成された順に product を取得することができます。
# 他の条件も同様です。
# ちなみに @sort というインスタンス変数は、現在適用されているソートの種類を識別するために使います。
# スコープを定義するためapp/models/application_record.rbへ行く
