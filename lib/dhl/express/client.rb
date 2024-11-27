# frozen_string_literal: true

module Dhl

  module Express

    class Client

      attr_reader :account_number, :username, :password, :billing_username, :billing_password, :sandbox

      def initialize(client_info)
        @account_number = client_info[:account_number]
        @username = client_info[:username]
        @password = client_info[:password]
        @billing_username = client_info[:billing_username]
        @billing_password = client_info[:billing_password]
        @sandbox = client_info[:sandbox] || false
      end

    end

  end

end
