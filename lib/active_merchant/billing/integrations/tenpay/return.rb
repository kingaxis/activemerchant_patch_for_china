require 'digest/md5'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Tenpay
        class Return < ActiveMerchant::Billing::Integrations::Return

          def account
            @params["bargainor_id"]
          end

          def order
            @params["sp_billno"]
          end

          def amount # 以分为单位
            @params["total_fee"]
          end

          def total_fee # 以元为单位
            @params["total_fee"].to_f / 100
          end

          def success?(key = KEY, local_account = ACCOUNT)
            return false unless @params["pay_result"] == "0"
            unless account == local_account
              @message = "Tenpay Error: INCORRECT_ACCOUNT"
              return false
            end

            hash_keys = %w(cmdno pay_result date transaction_id sp_billno total_fee fee_type attach)

            md5_string = hash_keys.inject([]){|array, key| array << "#{key}=#{@params[key]}"}.join("&")

            unless Digest::MD5.hexdigest(md5_string+"&key=#{key}") == @params["sign"].downcase
              @message = "Tenpay Error: ILLEGAL_SIGN"
              return false
            end

            return true
          end

          def message
            @message || @params['pay_info']
          end

        end
      end
    end
  end
end
