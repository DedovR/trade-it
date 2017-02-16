module TradeIt
  module User
    class Refresh < TradeIt::Base
      values do
        attribute :token, String
        attribute :ip, String, :default => nil
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/user/keepSessionAlive')

        body = {
          token: token,
          apiKey: TradeIt.api_key
        }

        result = execute(uri, body, ip)
        self.response = TradeIt::User.parse_result(result)

        self
      end
    end
  end
end
