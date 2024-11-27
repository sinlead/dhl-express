# frozen_string_literal: true

module Dhl

  module Express

    class ReconcileApi

      BASE_URL = "https://cship.dhl.com/APIService/api/v2"

      def post(request_params, path, bearer_token_str = nil)
        uri = URI("#{BASE_URL}#{path}")
        http = init_http(uri)
        request =
          if bearer_token_str.nil?
            Net::HTTP::Post.new(uri.request_uri)
          else
            Net::HTTP::Post.new(uri.request_uri, {  Authorization: bearer_token_str })
          end
        request.body = request_params.to_json
        request.content_type = "application/json"
        http.request(request)
      end

      private

      def init_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == "https"
        http.open_timeout = 90
        http.continue_timeout = 90
        http
      end

    end

  end

end
