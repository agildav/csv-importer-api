class EnableExtensions < ActiveRecord::Migration[6.0]
  def change
    enable_extension "plpgsql"
    enable_extension "unaccent"
  end
end
