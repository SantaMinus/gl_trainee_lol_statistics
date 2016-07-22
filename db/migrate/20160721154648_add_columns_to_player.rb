class AddColumnsToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :region, :string
    add_column :players, :api_key, :string
  end
end
