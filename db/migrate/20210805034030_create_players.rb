class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :headshot
      t.string :team
      t.string :bye_week

      t.timestamps
    end
  end
end
