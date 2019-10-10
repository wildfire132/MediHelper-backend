require 'byebug'

class MedicationsController < ApplicationController
    
    def get_medications_list_by_search_term 
        #This will start an API fetch for a list of medications that match the search term.
        byebug
        medicine_search_term = params["search_term"]
        response = RestClient.get("https://rxnav.nlm.nih.gov/REST/Prescribe/drugs.json/?name=#{medicine_search_term}") 
        medication_json = JSON.parse(response.body)

        @all_medications_list = {
            medications_results: []
        }

        medication_json["drugGroup"]["conceptGroup"].each do |med_concept|
            if med_concept["tty"] === "SCD"
                med_concept["conceptProperties"].each do |drug_type|
                    medication_hash = {
                    rxcui: drug_type["rxcui"],
                    name: drug_type["name"],
                    synonym: drug_type["synonym"],
                    }
                    @all_medications_list[:medication_results] << medication_hash
                end
            end
        end

        render :json => @all_medications_list
    end

    def check_for_contraindications
        #Start an API call with all of our User's medications rxcui numbers to see if there are any contraindications between their drugs.
        #Find by user then look for all their medications -> extract the rxcui numbers from each and feed it into the url below.
        byebug
        rxcui_numbers_list = params["search_term"]
        response = RestClient.get("https://rxnav.nlm.nih.gov/REST/interaction/list.json?rxcuis=#{rxcui_numbers_list}") 
        interaction_json = JSON.parse(response.body)
        byebug

        @interactions_list = {
            interactions:[]
        }
        
        interaction_json["fullInteractionTypeGroup"].each do |interactions|
            interactions["fullInteractionType"].each do |interaction|    
                interaction_hash = {
                    severity: interaction["interactionPair"][0]["severity"],
                    contraindication: interaction["interactionPair"][0]["description"],
                    firstDrug: {
                        rxcui:interaction["minConcept"][0]["rxcui"],
                        name:interaction["minConcept"][0]["name"]
                    },
                    secondDrug: {
                        rxcui:interaction["minConcept"][1]["rxcui"],
                        name:interaction["minConcept"][1]["name"]
                    }
                }
                @interactions_list[:interactions] << interaction_hash
            end
        end
        
        render :json => @interactions_list
    end
end
