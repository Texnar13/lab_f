class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.boolean :is_public
      t.datetime :when_created

      t.timestamps
    end
  end
end
