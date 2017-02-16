module TradeIt
  module User
    class LinkAndLogin < TradeIt::Base
      values do
        attribute :broker, Symbol
        attribute :username, String
        attribute :password, String
        attribute :ip, String, :default => nil
      end

      def call
        link = TradeIt::User::Link.new(
          broker: broker,
          username: username,
          password: password,
          ip: ip
        ).call.response

        self.response = TradeIt::User::Login.new(
          user_id: link.payload[:user_id],
          user_token: link.payload[:user_token],
          ip: ip
        ).call.response

        self
      end
    end
  end
end
