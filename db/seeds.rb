# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


CAT_COLORS = %w(black white orange brown)

20.times do
  User.create!(user_name: Faker::Internet.user_name, password: "password")
end

all_users = User.all.to_a

10.times do
  Cat.create!(birth_date: Faker::Date.backward(600),
    color: CAT_COLORS.sample, name: Faker::Hipster.word,
    description: Faker::Company.catch_phrase, user_id: all_users.sample.id,
    sex: ['M', 'F'].sample)
end

all_cats = Cat.all.to_a

50.times do
  start_days = rand(1..30)
  end_days = rand(5..60)
  until start_days < end_days
    start_days = rand(1..30)
    end_days = rand(5..60)
  end
  CatRentalRequest.create!(cat_id: all_cats.sample.id, user_id: all_users.sample.id,
    start_date: Faker::Date.backward(start_days), end_date: Faker::Date.forward(end_days))
end
