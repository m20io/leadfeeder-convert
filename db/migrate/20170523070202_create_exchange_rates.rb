class CreateExchangeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :exchange_rates, id: false do |t|
      t.date :date, primary: true
      t.decimal :us_dollar, precision: 10, scale: 4

      t.timestamps
    end
  end
end
