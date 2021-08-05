class AddTeamToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_reference :players, :team, index: true
    add_foreign_key :players, :teams
  end
end
