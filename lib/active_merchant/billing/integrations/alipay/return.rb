require 'active_merchant/billing/integrations/alipay/sign.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Alipay
        class Return < ActiveMerchant::Billing::Integrations::Return
          include Sign

          def order
            @params["out_trade_no"]
          end

          def trade_no # 支付宝交易号，需要保存到本地数据库，用于集成发货接口
            @params["trade_no"]
          end

          def amount
            @params["total_fee"]
          end

          def initialize(query_string)
            super
          end

          def success?(key = KEY)
            unless verify_sign(key)
              @message = "Alipay Error: ILLEGAL_SIGN"
              return false
            end

            true
          end

          def message
            @message
          end

        end
      end
    end
  end
end
