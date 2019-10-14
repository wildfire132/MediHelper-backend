class MedicationSerializer < ActiveModel::Serializer
  attributes :id, :name, :rxcui, :reminder, :medication_type
end
