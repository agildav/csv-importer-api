class CreateBadContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :bad_contacts do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :birth_date
      t.string :email
      t.string :phone
      t.string :address
      t.string :credit_card
      t.references :uploaded_file, foreign_key: true
      t.timestamps
    end
  end
end
