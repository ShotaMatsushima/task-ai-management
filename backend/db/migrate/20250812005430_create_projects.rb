class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.jsonb :technical_context

      t.timestamps
    end
  end
end
