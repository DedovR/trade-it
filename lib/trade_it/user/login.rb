module TradeIt
  module User
    class Login < TradeIt::Base
      values do
        attribute :user_id, String
        attribute :user_token, String
        attribute :ip, String, :default => nil
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/user/authenticate')

        body = {
          userId: user_id,
          userToken: user_token,
          apiKey: TradeIt.api_key
        }

        result = execute(uri, body, ip)

        self.response = TradeIt::User.parse_result(result)

        # TradeIt.logger.info response.to_h
        self
      end
    end
  end
end
