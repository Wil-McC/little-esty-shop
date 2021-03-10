# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Discount.destroy_all

@merchant1 = Merchant.find(1)
@merchant2 = Merchant.find(2)

disco1 = @merchant1.discounts.create!(percentage: 25, threshold: 5)
disco2 = @merchant1.discounts.create!(percentage: 50, threshold: 5)
disco3 = @merchant2.discounts.create!(percentage: 25, threshold: 3)
