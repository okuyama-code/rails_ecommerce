class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  scope :latest, -> { order(created_at: :desc) }
end

# ここで登場した scope とは、クラスメソッドを使う際、可読性を保つために使います。
# モデル名.latest とすると、created_at の値を 降順 で並び替えてくれます。
