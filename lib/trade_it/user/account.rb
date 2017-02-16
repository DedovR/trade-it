module TradeIt
  module User
    class Account < TradeIt::Base
      values do
        attribute :token, String
        attribute :account_number, String
        attribute :ip, String, :default => nil
      end

      def call
        uri =  URI.join(TradeIt.api_uri, 'api/v1/balance/getAccountOverview')

        body = {
          token: token,
          accountNumber: account_number,
          apiKey: TradeIt.api_key
        }

        req_result = execute(uri, body, ip)
        result     = JSON(req_result.body)
        if result['status'] == 'SUCCESS'
          payload = {
            type: 'success',
            cash: result['availableCash'].to_f,
            power: result['buyingPower'].to_f,
            day_return: result['dayAbsoluteReturn'].to_f,
            day_return_percent: result['dayPercentReturn'].to_f,
            total_return: result['totalAbsoluteReturn'].to_f,
            total_return_percent: result['totalPercentReturn'].to_f,
            value: result['totalValue'].to_f,
            token: result['token'],
            currency: result['accountBaseCurrency']
          }

          self.response = TradeIt::Base::Response.new(
            raw: result,
            payload: payload,
            messages: Array(result['shortMessage']),
            status: 200
          )
        else
          #
          # Status failed
          #
          raise TradeIt::Errors::LoginException.new(
            type: :error,
            code: result['code'],
            description: result['shortMessage'],
            messages: result['longMessages']
          )
        end
        self
      end

      def parse_time(time_string)
        Time.parse(time_string).utc.to_i
      rescue
        Time.now.utc.to_i
      end
    end
  end
end
