class CreateMedications < ActiveRecord::Migration[5.2]
  def change
    create_table :medications do |t|
      t.integer :user_id
      t.string :name
      t.integer :rxcui
      t.string :img_uri
      t.integer :reminder
      t.string :alternate_name
      t.string :medication_type

      t.timestamps
    end
  end
end
