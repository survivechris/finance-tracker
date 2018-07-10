require 'test_helper'

class StockTest < ActiveSupport::TestCase
  def test_stock_quote_shoult_respond_to_company_name
    looked_up_stock = StockQuote::Stock.quote('aapl')
    assert_equal("Apple Inc.", looked_up_stock.company_name)
  end
end
