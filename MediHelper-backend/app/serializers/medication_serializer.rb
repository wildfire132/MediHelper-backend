class MedicationSerializer < ActiveModel::Serializer
  attributes :id, :name, :rxcui, :reminder, :type
end
