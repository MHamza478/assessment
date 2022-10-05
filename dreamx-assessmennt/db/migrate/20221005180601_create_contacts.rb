class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, unique: true, null: false, index: true
      t.text :note

      t.timestamps
    end
  end
end
