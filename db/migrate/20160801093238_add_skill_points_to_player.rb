class AddSkillPointsToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :skill_points, :integer
  end
end
