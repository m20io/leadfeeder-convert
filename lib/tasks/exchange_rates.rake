require 'open-uri'

namespace :exchange_rates do
  desc 'Update the exchange rates in the database, if new one exist.'
  task update: :environment do
    file_name = Rails.root.join('tmp',"exchange_rates_#{Date.today.to_s}.csv")
    exchange_rates_url = 'http://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'

    unless File.exists?(file_name)
      begin
        open(file_name, 'w') do |file|
          file << open(exchange_rates_url).read
        end
      rescue SocketError => exception
        abort 'Unable to load new exchange_rates file. Please check your internet connection.'
      end
    end
    count_before = ExchangeRate.count
    ExchangeRatesImport.load(file_name)
    puts "Import finished. #{ExchangeRate.count - count_before} records added." \
        " Currently have #{ExchangeRate.count} exchange rates in the database."
  end

  desc 'Converts US Dollar in EUR, with date formated as "YYYY-MM-DD". Today is the default "date".'
  task :convert, [:amount, :date] => :environment do |t, args|
    args.with_defaults(date: Date.today.to_s)
    begin
      date = Date.parse(args[:date])
    rescue ArgumentError
      abort 'Unable to process date. Please use this format: YYYY-MM-DD (2017-05-01)'
    end

    if date > Date.today
      abort 'The requested date is in the future. The exchange rate is still unknown.'
    end

    begin
      us_amount = Float(args[:amount])
    rescue ArgumentError
      abort 'Unable to process amount. Please use this format: 110.12'
    end

    if us_amount > 10000000000000000000000
      abort 'You wish you had that kind of money...'
    end

    begin
      amount_euro = ExchangeRate.convert(us_amount, date)
    rescue ArgumentError => exception
      abort('Unable to convert: ' + exception.message)
    end

    puts "On the #{date.to_s(:long)} $#{'%.2f' % us_amount} could been exchanged for #{'%.2f' % amount_euro} €."
  end
end
