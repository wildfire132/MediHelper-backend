require 'json'
require 'rest-client'

class Medication < ApplicationRecord
    belongs_to :user

    def self.medication_type(medication_name)
        if medication_name.downcase.include?("oral")
            return "oral"
        elsif medication_name.downcase.include?("topical")
            return "topical"
        elsif medication_name.downcase.include?("injection")
            return "injection"
        else 
            return "other"
        end
    end

    def self.alphabetize_names(array_of_medication_objects)
        new_medication_array = array_of_medication_objects.sort do |medicationA,medicationB|
            medicationA.name.downcase <=> medicationB.name.downcase
        end
        puts new_medication_array
        return new_medication_array
    end
end
