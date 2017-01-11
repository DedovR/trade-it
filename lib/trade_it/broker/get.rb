module TradeIt
  module Broker
    class Get < TradeIt::Base

      def call
        uri  = URI.join(TradeIt.api_uri, 'api/v1/preference/getStocksOrEtfsBrokerList')
        body = {
          apiKey: TradeIt.api_key
        }
        result = Net::HTTP.post_form(uri, body)
        result = JSON(result.body)

        if 'SUCCESS' == result['status']
          self.response = TradeIt::Base::Response.new(raw: result,
                                                      status: 200,
                                                      payload: {
                                                        type: 'success',
                                                        brokers: result['brokerList']
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

        self
      end
    end
  end
end