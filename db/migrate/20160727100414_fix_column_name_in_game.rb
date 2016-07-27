class FixColumnNameInGame < ActiveRecord::Migration[5.0]
  def change
  	rename_column :games, :start, :start_time
  end
end
