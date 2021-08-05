class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :owner
      t.string :logo
      t.integer :draft_position

      t.timestamps
    end
  end
end
