require 'faker'

puts 'Cleaning database...'
Refueling.delete_all
GasStationProduct.delete_all
GasStation.delete_all
Address.delete_all
Product.delete_all
Wallet.delete_all
User.delete_all

puts 'Seeding users with wallets...'

5.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    wallet_attributes: {
      balance: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_f
    }
  )
end

puts 'Seeding gas stations with addresses...'

gas_stations = 5.times.map do
  GasStation.create!(
    name: Faker::Company.name,
    address_attributes: {
      street: Faker::Address.street_name,
      street_details: Faker::Address.secondary_address,
      number: Faker::Address.building_number,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip_code: Faker::Address.zip_code,
      acronym: AddressAcronym::STREET
    }
  )
end

puts 'Seeding products with gas station prices...'

products_data = [
  { name: 'Gasoline', discount: Discounts::GASOLINE, prices: [4.50, 4.55] },
  { name: 'Alcohol', discount: Discounts::ALCOHOL, prices: [3.80, 3.85] },
  { name: 'Diesel', discount: Discounts::DIESEL, prices: [4.00, 4.10] }
]

products_data.each do |product_data|
  product = Product.find_or_initialize_by(name: product_data[:name])
  product.discount = product_data[:discount]
  product.save!

  product_data[:prices].each_with_index do |price, i|
    gas_station = gas_stations[i]
    gsp = GasStationProduct.find_or_initialize_by(product: product, gas_station: gas_station)
    gsp.price_per_liter = price
    gsp.save!
  end
end

puts 'Seeding refuelings...'

users = User.all
gas_station_products = GasStationProduct.all
if gas_station_products.empty?
  puts 'No gas station products available, skipped refuelings seed.'
else
  20.times do
    user = users.sample
    next unless user&.wallet&.balance&.positive?

    gas_station_product = gas_station_products.sample
    next unless gas_station_product.present?

    product = gas_station_product.product
    gas_station = gas_station_product.gas_station

    liters = Faker::Number.decimal(l_digits: 1, r_digits: 2).to_f.round(2)

    price_calculator = RefuelingServices::PriceCalculator.new(
      liters: liters,
      product: product,
      gas_station: gas_station
    )

    price_data = price_calculator.calculate
    total_price = price_data[:total_price]
    discount_applied = price_data[:discount_applied]

    next if user.wallet.balance < total_price

    Refueling.create!(
      user: user,
      gas_station: gas_station,
      product: product,
      liters: liters,
      total_price: total_price,
      discount_applied: discount_applied
    )

    user.wallet.update!(balance: user.wallet.balance - total_price)
  end
end

puts 'Seeds finished.'
