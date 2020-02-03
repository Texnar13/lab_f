class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :mail
      t.string :name
      t.string :password_digest

      t.timestamps
    endt.string :title
    t.text :text
  end
end
