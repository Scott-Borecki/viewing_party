class CreateViewingParties < ActiveRecord::Migration[5.2]
  def change
    create_table :viewing_parties do |t|
      t.references :user, foreign_key: true
      t.integer :movie_id
      t.datetime :date_time
      t.integer :duration

      t.timestamps
    end
  end
end
