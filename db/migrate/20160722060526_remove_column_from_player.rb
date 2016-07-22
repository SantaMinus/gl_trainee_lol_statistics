class RemoveColumnFromPlayer < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :api_key, :string
  end
end
