class CreateMedications < ActiveRecord::Migration[5.2]
  def change
    create_table :medications do |t|
      t.integer :user_id
      t.string :name
      t.integer :rxcui
      t.string :img_uri
      t.string :alternate_name
      t.string :medication_type
      t.integer :remaining_doses
      t.integer :amount_taken_per_dose
      t.string :notification_start_date
      t.string :repeat_time
      t.string :repeat_days
      t.integer :dosages_left

      t.timestamps
    end
  end
end
