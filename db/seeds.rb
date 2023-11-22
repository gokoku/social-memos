User.create!(name:  "Example User",
              email: "example@example.com",
              password:              "foobar",
              password_confirmation: "foobar",
              admin:     true,
              activated: true,
              activated_at: Time.zone.now)

20.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
5.times do
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.microposts.create!(content: content) }
end