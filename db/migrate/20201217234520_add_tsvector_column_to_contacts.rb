class AddTsvectorColumnToContacts < ActiveRecord::Migration[6.0]
  def up
    add_column :contacts, :tsv, :tsvector
    add_index :contacts, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON contacts FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE contacts SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON contacts
    SQL

    remove_index :contacts, :tsv
    remove_column :contacts, :tsv
  end
end
