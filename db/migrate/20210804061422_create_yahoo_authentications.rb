class CreateYahooAuthentications < ActiveRecord::Migration[6.1]
  def change
    create_table :yahoo_authentications do |t|
      t.text :access_token
      t.string :refresh_token
      t.datetime :refresh_at

      t.timestamps
    end
  end
end
