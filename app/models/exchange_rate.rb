class ExchangeRate < ApplicationRecord
  validates :us_dollar, presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  def self.for_date(date)
    where('date <= ?', date).order(:date).last
  end

  def self.convert(us_dollar_amount, date)
    if us_dollar_amount < 0
      raise ArgumentError.new("Please enter a positive amount.")
    end
    begin
      Float(us_dollar_amount)
    rescue
      raise ArgumentError("No proper US Dollar amount is given.")
    end

    rate = for_date(date)
    if rate.blank?
      raise ArgumentError.new("No exchange rate available for date #{date.to_date}.")
    end
    rate.convert(BigDecimal.new(us_dollar_amount, 15))
  end

  def convert(us_dollar_amount)
    us_dollar_amount / us_dollar
  end
end
