class AddKdaColumnsToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :kills, :decimal
    add_column :players, :deaths, :decimal
    add_column :players, :assists, :decimal
    add_column :players, :kda, :decimal
  end
end
