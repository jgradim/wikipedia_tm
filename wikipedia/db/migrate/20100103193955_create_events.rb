class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :date
      t.text :description
      t.string :type
      t.string :who
      t.string :local
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end