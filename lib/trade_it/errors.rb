module TradeIt
  module Errors
    class TradeItException < Exception
      include Virtus.value_object

      values do
        attribute :type, Symbol
        attribute :code, Integer
        attribute :broker_code, Integer
        attribute :description, String
        attribute :messages, Array[String]
      end

      def message
        "#{type}\n#{code}\n#{broker_code}\n#{messages.join}\n#{description}"
      end
    end

    class LoginException < TradeItException
    end

    class ConfigException < TradeItException
    end

    class ConfigException < TradeItException
    end

    class PositionException < TradeItException
    end

    class OrderException < TradeItException
    end

    class RequestException < TradeItException
    end

    class ApiUnavailableException < TradeItException
    end
  end
end
