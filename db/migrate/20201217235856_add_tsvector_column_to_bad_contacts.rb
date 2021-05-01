class AddTsvectorColumnToBadContacts < ActiveRecord::Migration[6.0]
  def up
    add_column :bad_contacts, :tsv, :tsvector
    add_index :bad_contacts, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON bad_contacts FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE bad_contacts SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON bad_contacts
    SQL

    remove_index :bad_contacts, :tsv
    remove_column :bad_contacts, :tsv
  end
end
