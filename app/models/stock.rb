class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless looked_up_stock.company_name

    new_stock = Stock.new(ticker: looked_up_stock.symbol,
                          name: looked_up_stock.company_name)
    new_stock.last_price = new_stock.price

    new_stock
  end

  def price
    # ticker has already defined in the instance
    closing_price = StockQuote::Stock.quote(ticker).close
    return "#{closing_price}(closing)" if closing_price
    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price}(opening)" if opening_price
    'Unavailable'
  end
end
