require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do

  it 'stores us_dollar without changing' do
    us_dollar_value = BigDecimal.new(1.2345, 4)
    exchange_rate = ExchangeRate.create(date: 1.week.ago, us_dollar: us_dollar_value)
    expect(exchange_rate.us_dollar).to eql us_dollar_value
  end

  context 'to be valid' do
    let(:exchange_rate) do
      ExchangeRate.new(date: Date.today, us_dollar: 1.1234)
    end

    it 'requires a us_dollar value' do
      exchange_rate.us_dollar = nil
      expect(exchange_rate).not_to be_valid
    end

    it 'requires us_dollar to be positive' do
      exchange_rate.us_dollar = -1
      expect(exchange_rate).not_to be_valid
    end
  end

  describe '.for_date' do
    let!(:latest_exchange_rate) do
      ExchangeRate.create(date: 1.week.ago, us_dollar: 1.2345)
    end
    let!(:first_exchange_rate) do
      ExchangeRate.create(date: 2.week.ago, us_dollar: 2.3456)
    end

    it 'returns the last existing exchange_rate before the date' do
      exchange_rate = ExchangeRate.for_date(1.day.ago)
      expect(exchange_rate.date).to eql latest_exchange_rate.date
    end
    it 'returns the exchange_rate of this date' do
      exchange_rate = ExchangeRate.for_date(2.week.ago)
      expect(exchange_rate.date).to eql first_exchange_rate.date
    end
    it 'returns nil if no exchange exsits' do
      expect(ExchangeRate.for_date(3.week.ago)).to be_nil
    end
  end

  describe '.convert' do
    before do
      ExchangeRate.create(date: 1.week.ago, us_dollar: 2)
      ExchangeRate.create(date: 2.week.ago, us_dollar: 4)
    end

    it 'converts with the correct exchange rate' do
      expect(ExchangeRate.convert(10, 1.day.ago)).to eql 5
      expect(ExchangeRate.convert(10, 10.day.ago)).to eql 2.5
    end

    it 'raises an error if no exchange rate is available' do
      expect{ ExchangeRate.convert(10, 3.weeks.ago) }
        .to raise_error(ArgumentError,
          "No exchange rate available for date #{3.weeks.ago.to_date}.")
    end

    it 'raise an error if a negatie value was given' do
      expect{ ExchangeRate.convert(-10, 1.weeks.ago) }
        .to raise_error(ArgumentError)
    end

    it 'raise an error if not a number is given' do
      expect{ ExchangeRate.convert('something', 1.weeks.ago) }
        .to raise_error(ArgumentError)
    end
  end

  describe '#convert' do
    let(:exchange_rate) do
      ExchangeRate.new(date: Date.today, us_dollar: 2.0000)
    end
    it 'converts to euro' do
      expect(exchange_rate.convert(10)).to eql 5
      expect(exchange_rate.convert(5)).to eql 2.5
    end
  end
end
