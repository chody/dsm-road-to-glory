class RenameTeamName < ActiveRecord::Migration[6.1]
  def change
    rename_column :players, :team, :nfl_team
  end
end
