
# User based actions from the Tradeit API
#
#
module TradeIt
  module Account
    autoload :TransactionsHistory, 'trade_it/account/transactions_history'

    class << self

      def parse_result(result)
        result = JSON(result.body)
        if result['status'] == 'SUCCESS'
          #
          # User logged in without any security questions
          #
          transactions = result['transactionHistoryDetailsList'].map do |p|
            TradeIt::Base::Transaction.new(
              action:      p['action'],
              amount:      p['amount'],
              commission:  p['commission'],
              date:        p['date'],
              description: p['description'],
              id:          p['id'],
              price:       p['price'],
              quantity:    p['quantity'],
              symbol:      p['symbol'],
              type:        p['type'],
            ).to_h
          end
          response     = TradeIt::Base::Response.new(raw:      result,
                                                     status:   200,
                                                     payload:  {
                                                       transactions: transactions,
                                                     },
                                                     messages: [result['shortMessage']].compact)
        else
          #
          # Transactions failed
          #
          raise TradeIt::Errors::TransactionException.new(
                  type:        :error,
                  code:        result['code'],
                  description: result['shortMessage'],
                  messages:    result['longMessages']
                )
        end
        response
      end
    end
  end
end