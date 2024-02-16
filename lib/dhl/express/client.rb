# frozen_string_literal: true

module Dhl

  module Express

    class Client

      attr_reader :account_number, :username, :password, :sandbox

      def initialize(client_info)
        @account_number = client_info[:account_number]
        @username = client_info[:username]
        @password = client_info[:password]
        @sandbox = client_info[:sandbox] || false
      end

    end

  end

end
