require 'rails_helper'

RSpec.describe ExchangeRatesImport do
  let(:file_name) { Rails.root.join('spec','fixtures', 'exchange_rates_exmaple.csv') }
  before { ExchangeRatesImport.load(file_name) }
  describe '.load' do
    it 'creates all three exchange rates from the file' do
      expect(ExchangeRate.count).to eql 3
    end

    it 'creates them with correct dates and amounts' do
      expect(ExchangeRate.for_date(Date.new(2017,05,22)).us_dollar).to eql 1.1243
      expect(ExchangeRate.for_date(Date.new(2017,05,19)).us_dollar).to eql 1.1179
      expect(ExchangeRate.for_date(Date.new(2017,05,18)).us_dollar).to eql 1.1129
    end
  end
end