module TradeIt
  module Positions
    class Get < TradeIt::Base
      values do
        attribute :token, String
        attribute :account_number, String
        attribute :page, Integer, default: 0
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/position/getPositions')

        body = {
          token: token,
          accountNumber: account_number,
          page: page,
          apiKey: TradeIt.api_key
        }

        result = execute(uri, body)

        self.response = TradeIt::Positions.parse_result(result)
        self
      end
    end
  end
end
