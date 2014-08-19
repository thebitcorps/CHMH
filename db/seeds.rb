# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = User.create(
    :name => "Omar",
    :lastname => "De Anda",
    :email => "odaman09@gmail.com",
    :password => "devicedev",
    :password_confirmation => "devicedev",
    :role => 'Admin'
)
admin = User.create(
    :name => "Felipe de Jesus",
    :lastname => "Flores Parkman Sevilla",
    :email => "watsonmex@gmail.com",
    :password => "devicedev",
    :password_confirmation => "devicedev",
    :role => 'Admin'
)