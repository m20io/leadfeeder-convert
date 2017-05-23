# US Dollar Converter to EUR

With this tools you can convert US Dollar in to EUR at exchange rates given by the European Central Bank.

# Setup

Please run the following command to setup the tool. You need to have the ruby gem *bundler* installed.

`git clone git@github.com:m20io/leadfeeder-convert.git`

`bundle`

`bin/rake db:setup`

# Usage

With the following command you can update the exchange rates:
`bin/rake exchange_rates:update`

And with the following command you convert US Dollar into EUR:

`bin/rake exchange_rates:convert[100.10]` converts $100.10 with today's exchange rate

`bin/rake exchange_rates:convert[100.10, 2010-01-01]` converts $100.10 with the exchange rate from the first of January 2010.