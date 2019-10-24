require 'byebug'

class MedicationsController < ApplicationController

    def index
        @medications = Medication.all
        render :json => @medications
    end

    def create
        @user = User.find_by(id:params["userID"])
        @type = Medication.medication_type(params["medication"]["name"])

        @total_dosages = Medication.calculate_total_dosages(params["dosesRemaining"].to_i, params["amountUsedPerDose"].to_i)

        new_medication = Medication.create(
            user_id: params["userID"],
            rxcui: params["medication"]["rxcui"],
            name: params["medication"]["name"],
            alternate_name: params["medication"]["synonym"],
            img_uri: "",
            remaining_doses: params["dosesRemaining"].to_i,
            amount_taken_per_dose: params["amountUsedPerDose"].to_i,
            notification_start_date: params["notificationStartDate"],
            repeat_time: params["repeatIntervalTime"],
            repeat_days: params["repeatIntervalDays"],
            dosages_left: @total_dosages,
            medication_type: @type)
        
        @sorted = Medication.alphabetize_names(@user.medications)

        render :json => @sorted
    end 

    def change_image
        @medication = Medication.all.find_by(id: params["medication"]["id"])
        @medication.update(img_uri: params["photoData"]["uri"])
        @user = User.all.find_by(id: params["userID"])

        @sorted = Medication.alphabetize_names(@user.medications)

        render :json => @sorted
    end

    def update_dosage
        @medication = Medication.all.find_by(id: params["medication"]["id"])
        new_dosage = (@medication.dosages_left) - 1
        @medication.update(dosages_left: new_dosage)
        @user = User.all.find_by(id: params["user_id"])

        @sorted = Medication.alphabetize_names(@user.medications)

        render :json => @sorted
    end

    def delete_medication
        @user = User.find_by(id: params["userID"])
        @medication = Medication.all.find_by(id: params["medication"]["id"])
        @medication.delete()

        @sorted = Medication.alphabetize_names(@user.medications)

        render :json => @sorted
    end

    def get_users_medications
        @user = User.find_by(id: params["userID"])

        @sorted = Medication.alphabetize_names(@user.medications)

        render :json => @sorted
    end
    
    def get_medications_list_by_search_term 
        #This will start an API fetch for a list of medications that match the search term.
        medicine_search_term = params["search_term"]
        response = RestClient.get("https://rxnav.nlm.nih.gov/REST/Prescribe/drugs.json/?name=#{medicine_search_term}") 
        medication_json = JSON.parse(response.body)

        @all_medications_list = {
            search_term: medicine_search_term,
            medications_results: [],
            results_available: false,
            oral_medications: [],
            topical_medications: [],
            injection_medications: [],
            other_medications: []
        }

        if !!medication_json["drugGroup"]["conceptGroup"] 
            med_concept = medication_json["drugGroup"]["conceptGroup"].last

            @all_medications_list["results_available"] = true

            med_concept["conceptProperties"].each do |drug_type|
                type = Medication.medication_type(drug_type["name"])

                medication_hash = {
                rxcui: drug_type["rxcui"],
                name: drug_type["name"],
                synonym: drug_type["synonym"],
                type: type
                }
                @all_medications_list[:medications_results] << medication_hash
                @all_medications_list[:"#{type}_medications"] << medication_hash
            end
        end
        render :json => @all_medications_list
    end

    def check_for_contraindications
        #Start an API call with all of our User's medications rxcui numbers to see if there are any contraindications between their drugs.
        #Find by user then look for all their medications -> extract the rxcui numbers from each and feed it into the url below.
        @user = User.find_by(id:params["user_id"])
        rxcui_array = @user.medications.map {|medication| medication.rxcui} 
        rxcui_numbers_list = rxcui_array.join("+")

        response = RestClient.get("https://rxnav.nlm.nih.gov/REST/interaction/list.json?rxcuis=#{rxcui_numbers_list}") 
        interaction_json = JSON.parse(response.body)

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
