class CreateUploadedFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :uploaded_files do |t|
      t.references :user, foreign_key: true
      t.string :filename, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
