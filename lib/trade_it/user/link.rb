module TradeIt
  module User
    class Link < TradeIt::Base
      values do
        attribute :broker, Symbol
        attribute :username, String
        attribute :password, String
      end

      def call
        uri  = URI.join(TradeIt.api_uri, 'api/v1/user/oAuthLink')
        body = {
          id: username,
          password: password,
          broker: TradeIt.brokers[broker],
          apiKey: TradeIt.api_key
        }
        result = Net::HTTP.post_form(uri, body)
        result = JSON(result.body)

        if 'SUCCESS' == result['status']
          self.response = TradeIt::Base::Response.new(raw: result,
                                                      status: 200,
                                                      payload: {
                                                        type: 'success',
                                                        user_id: result['userId'],
                                                        user_token: result['userToken']
                                                      },
                                                      messages: [result['shortMessage']].compact)
        else
          raise TradeIt::Errors::LoginException.new(
            type: :error,
            code: result['code'],
            description: result['shortMessage'],
            messages: result['longMessages']
          )
        end
        # pp response.to_h
        # TradeIt.logger.info response.to_h
        self
      end
    end
  end
end
