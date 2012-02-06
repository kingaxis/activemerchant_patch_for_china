require File.dirname(__FILE__) + '/tenpay/helper.rb'
require File.dirname(__FILE__) + '/tenpay/return.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Tenpay

        mattr_accessor :service_url
        self.service_url = 'http://service.tenpay.com/cgi-bin/v3.0/payservice.cgi'

        def self.return(query_string)
          Return.new(query_string)
        end
      end
    end
  end
end
