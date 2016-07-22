class AddColumnToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :winrate, :decimal
  end
end
