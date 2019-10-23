class MedicationSerializer < ActiveModel::Serializer
  attributes :id, :name, :rxcui, :img_uri, :remaining_doses, :amount_taken_per_dose, :notification_start_date, :repeat_time, :repeat_days, :medication_type, :dosages_left
end
