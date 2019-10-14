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
end
