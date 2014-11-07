# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


 User.create(
    :name => "Omar",
    :lastname => "De Anda",
    :email => "odaman09@gmail.com",
    :password => "devicedev",
    :password_confirmation => "devicedev",
    :birthday => Date.today,
    :gender => "0",
    :minutes => 0,
    :role => 'Admin'
)
 User.create(
    :name => "Felipe de Jesus",
    :lastname => "Flores Parkman",
    :email => "watsonmex@gmail.com",
    :password => "devicedev",
    :password_confirmation => "devicedev",
    :birthday => Date.today,
    :gender => "0",
    :minutes => 0,
    :role => 'Admin'
)