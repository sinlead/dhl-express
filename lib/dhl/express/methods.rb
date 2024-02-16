# frozen_string_literal: true

module Dhl

  module Express

    class Methods

      attr_reader :client

      def initialize(client)
        @client = client
      end

      def retrieve_rates_for_one_piece(data)
        path = "/rates"
        dhl_api.get({ username: client.username, password: client.password }, data, path)
      end

      def retrieve_rates_for_multi_piece(data)
        path = "/rates"
        dhl_api.post({ username: client.username, password: client.password }, data, path)
      end

      def create_shipment(data)
        path = "/shipments"
        dhl_api.post({ username: client.username, password: client.password }, data, path)
      end

      def track_shipments(data)
        path = "/tracking"
        dhl_api.get({ username: client.username, password: client.password }, data, path)
      end

      private

      def dhl_api
        Dhl::Express::Api.new({ sandbox: client.sandbox })
      end

    end

  end

end
