class AddPostIdToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :post_id, :integer
  end
end
