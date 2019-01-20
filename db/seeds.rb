# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

names = ['두근두근 용', '공작새', '호랑이']

3.times do |index|
  painting = Painting.create!(name: names[index], desc: names[index]+'입니다')
  painting.thumbnail.store!(File.open(File.join(Rails.root, "/public/seeds/seed_#{index}_thumb.JPG")))
  painting.images = [
    File.open(File.join(Rails.root, "/public/seeds/seed_#{index}_image.JPG"))
  ]
  painting.save
end