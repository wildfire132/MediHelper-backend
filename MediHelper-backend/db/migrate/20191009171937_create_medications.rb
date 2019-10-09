class CreateMedications < ActiveRecord::Migration[5.2]
  def change
    create_table :medications do |t|
      t.integer :user_id
      t.string :name
      t.integer :rxcui
      t.integer :reminder
      t.string :medication_type

      t.timestamps
    end
  end
end
