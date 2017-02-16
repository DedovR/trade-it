module TradeIt
  module User
    class Unlink < TradeIt::Base
      values do
        attribute :token, String
        attribute :user_id, String
        attribute :ip, String, :default => nil
      end

      def call
        uri  = URI.join(TradeIt.api_uri, 'api/v1/user/oAuthDelete')
        body = {
          userToken: token,
          userId: user_id,
          apiKey: TradeIt.api_key
        }
        byebug
        result = JSON(execute(uri, body, ip).body)

        if 'SUCCESS' == result['status']
          self.response = TradeIt::Base::Response.new(raw: result,
                                                      status: 200,
                                                      payload: {
                                                        type: 'success',
                                                        user_token: result['userToken']
                                                      },
                                                      messages: [result['shortMessage']].compact)
        else
          raise TradeIt::Errors::TradeItException.new(
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
