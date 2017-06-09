User.create(
    name: "Omar",
    lastname: "De Anda",
    email: "odaman09@gmail.com",
    password: "devicedev",
    password_confirmation: "devicedev",
    birthday: Date.today,
    gender: "0",
    minutes: 0,
    role: 'Admin'
)
 User.create(
    name: "Felipe de Jesus",
    lastname: "Flores Parkman",
    email: "watsonmex@gmail.com",
    password: "devicedev",
    password_confirmation: "devicedev",
    birthday: Date.today,
    gender: "0",
    minutes: 0,
    role: 'Admin'
)
User.create(name: 'Developer', lastname: 'Lastname', email: 'dev@thebitcorps.com',
            password: '12345678', birthday: 30.years.ago, gender: '0', minutes: 0, role: 'Admin')
