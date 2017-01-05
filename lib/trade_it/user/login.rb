module TradeIt
  module User
    class Login < TradeIt::Base
      values do
        attribute :user_id, String
        attribute :user_token, String
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/user/authenticate')

        body = {
          userId: user_id,
          userToken: user_token,
          apiKey: TradeIt.api_key
        }

        result = Net::HTTP.post_form(uri, body)
        date   = Time.parse(result['Date']).to_i
        result = JSON(result.body)

        self.response = TradeIt::User.parse_result(result, date)

        # TradeIt.logger.info response.to_h
        self
      end
    end
  end
end
