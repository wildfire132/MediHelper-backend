require 'json'
require 'rest-client'

class Medication < ApplicationRecord
    belongs_to :user
end
