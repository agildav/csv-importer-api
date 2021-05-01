puts "Seed: Users".magenta
puts ("="*25).magenta

User.destroy_all
User.reset_pk_sequence

User.create!({
  email: "agildav@gmail.com",
  password: "123456"
})

(0..15).each do |seq|
  User.create!({
    email: "user_#{seq}@test.com",
    password: "123456"
  })
end