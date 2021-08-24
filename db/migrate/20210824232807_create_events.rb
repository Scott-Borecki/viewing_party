class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.bigint :movie_id
      t.datetime :date_time
      t.integer :duration

      t.timestamps
    end
  end
end
