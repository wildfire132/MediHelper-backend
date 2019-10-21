class MedicationSerializer < ActiveModel::Serializer
  attributes :id, :name, :rxcui, :reminder, :medication_type, :img_uri
end
