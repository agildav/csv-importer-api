class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.date :birth_date, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.string :credit_card, null: false
      t.references :uploaded_file, foreign_key: true
      t.timestamps
    end
  end
end
