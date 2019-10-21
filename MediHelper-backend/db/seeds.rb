# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

User.destroy_all
Medication.destroy_all

def create_users
    50.times do 
        User.create(name:Faker::Name.unique.name, username: Faker::Coffee.blend_name, email: "1234@gmail.com", img_url:"https://www.freepngimg.com/thumb/doctor_symbol/2-2-doctor-symbol-caduceus-png-clipart-thumb.png", token: "")
    end
    puts "created users"
end

create_users