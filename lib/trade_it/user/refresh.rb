module TradeIt
  module User
    class Refresh < TradeIt::Base
      values do
        attribute :token, String
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/user/keepSessionAlive')

        body = {
          token: token,
          apiKey: TradeIt.api_key
        }

        result = Net::HTTP.post_form(uri, body)
        result = JSON(result.body)
        self.response = TradeIt::User.parse_result(result)

        # TradeIt.logger.info response.to_h
        self
      end
    end
  end
end
