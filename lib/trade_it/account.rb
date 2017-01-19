# User based actions from the Tradeit API
#
#
module TradeIt
  module Account
    autoload :Get, 'trade_it/account/transactions_history'

    class << self

	  def parse_result(result)
          result = JSON(result.body)
	    if result['status'] == 'SUCCESS'
	      #
	      # User logged in without any security questions
	      #
	      transactions = result['positions'].map do |p|
	        TradeIt::Base::Position.new(
	          quantity: p['quantity'],
	          cost_basis: p['costbasis'],
	          ticker: p['symbol'],
	          instrument_class: p['symbolClass'].downcase,
	          change: p['totalGainLossDollar'],
	          holding: p['holdingType'].downcase
	        ).to_h
	      end
	      response = TradeIt::Base::Response.new(raw: result,
	                                             status: 200,
	                                             payload: {
	                                               transactions: transactions,
	                                             },
	                                             messages: [result['shortMessage']].compact)
	    else
	      #
	      # Transactions failed
	      #
	      raise TradeIt::Errors::TransactionException.new(
	        type: :error,
	        code: result['code'],
	        description: result['shortMessage'],
	        messages: result['longMessages']
	      )
	    end
	    response
      end
    end
  end
end