module TradeIt
  module User
    class Logout < TradeIt::Base
      values do
        attribute :token, String
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/user/closeSession')

        body = {
          token: token,
          apiKey: TradeIt.api_key
        }

        result = execute(uri, body)
        self.response = TradeIt::User.parse_result(result)

        self
      end
    end
  end
end
