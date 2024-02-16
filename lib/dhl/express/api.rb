# frozen_string_literal: true

module Dhl

  module Express

    class Api

      attr_reader :sandbox

      def initialize(options = { sandbox: false })
        @sandbox = options[:sandbox]
      end

      def api_base_url
        if sandbox
          "https://express.api.dhl.com/mydhlapi/test"
        else
          "https://express.api.dhl.com/mydhlapi"
        end
      end

      def get(auth, request_params, path)
        uri = URI("#{api_base_url}#{path}?#{URI.encode_www_form(request_params)}")
        http = init_http(uri)
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(auth[:username], auth[:password])
        http.request(request)
      end

      def post(auth, request_params, path)
        uri = URI("#{api_base_url}#{path}")
        http = init_http(uri)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.basic_auth(auth[:username], auth[:password])
        request.body = request_params.to_json
        request.content_type = "application/json"
        http.request(request)
      end

      private

      def init_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == "https"
        http.open_timeout = 10
        http.continue_timeout = 10
        http
      end

    end

  end

end
