require 'digest/md5'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Tenpay
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          # Replace with the real mapping
          mapping :account, 'bargainor_id' # 商家的商户号,由腾讯公司唯一分配
          mapping :amount, 'total_fee' # 总金额，以分为单位

          mapping :order, 'sp_billno' # 商户系统内部的定单号，此参数仅在对账时提供,28个字符内(正在测试是否支持32位)。

          mapping :cmdno, 'cmdno' # 必填:业务代码, 财付通支付支付接口填  1
          mapping :date, 'date'  # 必填 商户日期：如20051212

          mapping :return_url, 'return_url' # 接收财付通返回结果的URL(服务器地址，接收后服务器要返回show_url的值，财付通将此show_url发送给用户浏览器)
          mapping :description, 'desc' # 必填 交易的商品名称,32个字符16汉字内,不包含特殊符号
          mapping :attach, 'attach' # 商家数据包，原样返回
          mapping :currency, 'fee_type' # 现金支付币种，目前只支持人民币
          mapping :transaction_id, 'transaction_id' # 交易号(订单号)，由商户网站产生(建议顺序累加)，一对请求和应答的交易号必须相同）transaction_id 为28位长的数值，其中前10位为商户网站编号(SPID)，由财付通统一分配；之后8位为订单产生的日期，如20050415；最后10位商户需要保证一天内不同的事务
          mapping :spbill_create_ip, 'spbill_create_ip' # 用户IP（非商户服务器IP），为了防止欺诈，支付时财付通会校验此IP。（此值必填，否则报签名不正确）
          mapping :charset, 'cs' # 字符编码标准，gbk或者utf-8

          def initialize(order, account, options = {})
            super
            add_field('bank_type', 0)
            add_field('purchaser_id', '') # 用户(买方)的财付通帐户(QQ或EMAIL),如无法获取，填空值
          end

          def sign(key = KEY)
            add_field('sign',
                      Digest::MD5.hexdigest("cmdno=#{cmdno}&date=#{date}&bargainor_id=#{account}" +
                      "&transaction_id=#{transaction_id}&sp_billno=#{order}&total_fee=#{amount}" +
                      "&fee_type=#{currency}&return_url=#{return_url}&attach=#{attach}&spbill_create_ip=#{spbill_create_ip}&key=#{key}"))
            nil
          end

        end
      end
    end
  end
end
