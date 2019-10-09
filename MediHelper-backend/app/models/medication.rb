require 'json'
require 'rest-client'

class Medication < ApplicationRecord
    belongs_to :user

    def get_medications_list_by_search_term(medicine_search_term) 
        #This will start an API fetch for a list of medications that match the search term.  
        response = RestClient.get("https://rxnav.nlm.nih.gov/REST/Prescribe/drugs.json/?name=#{medicine_search_term}") 
        medication_json = JSON.parse(response.body)

        medication_json["drugGroup"]["conceptGroup"].each do |med_concept|
            if med_concept["tty"] === "SCD"
                med_concept["conceptProperties"].each do |drug_type|
                    puts drug_type["rxcui"]
                    puts drug_type["name"]
                    puts drug_type["synonym"]
                end
            end
        end
    end

    def check_for_contraindications(rxcui_numbers_list)
        #Start an API call with all of our User's medications rxcui numbers to see if there are any contraindications between their drugs.
        response = RestClient.get("https://rxnav.nlm.nih.gov/REST/interaction/list.json?rxcuis=#{rxcui_numbers_list}") 
        interaction_json = JSON.parse(response.body)
        byebug

        interaction_json["fullInteractionTypeGroup"].each do |interactions|
            interactions["fullInteractionType"].each do |interaction|
                    puts interaction["interactionPair"][0]["severity"]
                    puts interaction["interactionPair"][0]["description"]
                interaction["minConcept"].each do |my_medication|
                    puts my_medication["rxcui"]
                    puts my_medication["name"]
                end
            end
        end
    end
end
