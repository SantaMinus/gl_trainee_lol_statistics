class AddRelations < ActiveRecord::Migration[5.0]
  def change
    add_reference :players, :users, index: true
    add_reference :users, :players, index: true
  end
end
