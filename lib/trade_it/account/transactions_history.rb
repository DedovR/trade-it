module TradeIt
  module Account
    class TransactionsHistory < TradeIt::Base
      values do
        attribute :token, String
        attribute :account_number, String
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/account/getAllTransactionsHistory')

        body = {
          token: token,
          accountNumber: account_number,
          apiKey: TradeIt.api_key
        }

        result = execute(uri, body)

        self.response = TradeIt::Account.parse_result(result)
        self
      end
    end
  end
end