module TradeIt
  module User
    class Verify < TradeIt::Base
      values do
        attribute :token, String
        attribute :answer, String
        attribute :srv, String
        attribute :ip, String, :default => nil
      end

      def call
        uri  = URI.join(TradeIt.api_uri, 'api/v1/user/answerSecurityQuestion')

        body = {
          securityAnswer: answer,
          token: token,
          srv: srv,
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
