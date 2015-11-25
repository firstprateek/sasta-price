class AddColumnsToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :link, :string
  	add_column :products, :vendor, :string
  end
end
