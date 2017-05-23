require 'csv'

class ExchangeRatesImport
  def self.load(file_name)
    CSV.foreach(file_name, skip_lines: /^[a-zA-Z\s\W].+/) do |rate_row|
      begin
        Float(rate_row[1])
      rescue ArgumentError
        next
      end

      ExchangeRate.find_or_create_by(date: Date.parse(rate_row[0])
        ) do |exchange_rate|
          exchange_rate.us_dollar = BigDecimal.new(Float(rate_row[1]), 10)
      end
    end
  end
end