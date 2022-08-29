class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.belongs_to :user, index: {unique: true}, foreign_key: true
      t.text :token, null: false
      t.timestamps
    end
  end
end
