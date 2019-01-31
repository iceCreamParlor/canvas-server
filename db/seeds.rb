# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

names = ['두근두근 용', '공작새', '호랑이']

50.times do |index|
  painting = Painting.create!(color: Color.first, user: User.first, category_id: 1,name: names[index], desc: names[0]+'입니다')
  painting.thumbnail.store!(File.open(File.join(Rails.root, "/public/seeds/seed_2_thumb.JPG")))
  painting.images = [
    File.open(File.join(Rails.root, "/public/seeds/seed_1_image.JPG"))
  ]
  painting.save
end