class Customer::CartItemsController < ApplicationController
  # current_customer に現在ログインしている顧客の情報が格納されるようにしています。(全アクション)
  before_action :authenticate_customer!
  before_action :set_cart_item, only: %i[increase decrease destroy]

  def index
    # この変数　current_customer.cart_itemsにはログインしている顧客のショッピングカート内の各商品の情報や数量などが含まれる
    @cart_items = current_customer.cart_items
    @total = @cart_items.inject(0) { |sum, cart_item| sum + cart_item.line_total }
  end

  def create
    # カートへの商品の追加 or 既にカート内に存在する商品の個数の更新 を行う。この処理を increase_or_create というメソッドに切り出しました。
  increase_or_create(params[:cart_item][:product_id])
  redirect_to cart_items_path, notice: 'カートに商品を追加することに成功しました。'
  end

  def increase
    @cart_item.increment!(:quantity, 1)
    redirect_to request.referer, notice: '商品の数量を一つ追加しました'
  end

  def decrease
    decrease_or_destroy(@cart_item)
    redirect_to request.referer, notice: '商品の数量を一つ削除しました'
  end

  def destroy
    @cart_item.destroy
    redirect_to request.referer, notice: '1つのカート項目が正常に削除されました'
  end

  private

  def set_cart_item
    # ログインしている顧客に紐づいたショッピングカートアイテムのコレクションの中からcart_itemsのidがパラメータのidと同じものを取得し@cart_itemに格納する？
    @cart_item = current_customer.cart_items.find(params[:id])
  end

  def increase_or_create(product_id)
    # 現在ログインしている顧客のカート内商品の中から、顧客がカートに追加しようとしている商品を探しています。その結果を cart_item という変数に格納しています。(product_id:) はハッシュのキーとして使われている
    cart_item = current_customer.cart_items.find_by(product_id:)
    if cart_item
      # カート内商品の個数を1増やす
      cart_item.increment!(:quantity, 1)
    else
      #カート内商品を新たに作成しています。current_customer.cart_items.build と書くことで、現在ログインしている顧客に紐づける（customer_id に current_customer の id をセットする）ことができます。あとは、product_id をセットして、保存すれば新たにカート内商品が作成されるというわけです。（quantity にはデフォルト値である 1 がセットされています。）
      current_customer.cart_items.build(product_id:).save
    end

    def decrease_or_destroy(cart_item)
      if cart_item.quantity > 1
        cart_item.decrement!(:quantity, 1)
      else
        cart_item.destroy
      end
    end

  end
end
