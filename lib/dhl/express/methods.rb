# frozen_string_literal: true

module Dhl

  module Express

    class Methods

      KEYS_OF_RETRIEVE_RATES_FOR_ONE_PIECE = %i[
        accountNumber originCountryCode originPostalCode originCityName destinationCountryCode destinationPostalCode
        destinationCityName weight length width height plannedShippingDate isCustomsDeclarable unitOfMeasurement
        nextBusinessDay strictValidation getAllValueAddedServices requestEstimatedDeliveryDate estimatedDeliveryDateType
      ].freeze

      KEYS_OF_RETRIEVE_RATES_FOR_MULTI_PIECE = %i[
        customerDetails accounts productCode localProductCode valueAddedServices productsAndServices payerCountryCode
        plannedShippingDateAndTime unitOfMeasurement isCustomsDeclarable monetaryAmount estimatedDeliveryDate
        getAdditionalInformation returnStandardProductsOnly nextBusinessDay productTypeCode packages
      ].freeze

      KEYS_OF_CREATE_SHIPMENT = %i[
        plannedShippingDateAndTime pickup productCode localProductCode getRateEstimates accounts valueAddedServices
        outputImageProperties customerReferences identifiers customerDetails content documentImages onDemandDelivery
        requestOndemandDeliveryURL shipmentNotification prepaidCharges getTransliteratedResponse estimatedDeliveryDate
        getAdditionalInformation parentShipment
      ].freeze

      KEYS_OF_TRACK_SHIPMENTS = %i[
        shipmentTrackingNumber pieceTrackingNumber shipmentReference shipmentReferenceType shipperAccountNumber
        dateRangeFrom dateRangeTo trackingView levelOfDetail
      ].freeze

      attr_reader :client

      def initialize(client)
        @client = client
      end

      def retrieve_rates_for_one_piece(data)
        path = "/rates"
        request_params = data.slice(*KEYS_OF_RETRIEVE_RATES_FOR_ONE_PIECE)
        dhl_api.get({ username: client.username, password: client.password }, request_params, path)
      end

      def retrieve_rates_for_multi_piece(data)
        path = "/rates"
        request_params = data.slice(*KEYS_OF_RETRIEVE_RATES_FOR_MULTI_PIECE)
        dhl_api.post({ username: client.username, password: client.password }, request_params, path)
      end

      def create_shipment(data)
        path = "/shipments"
        request_params = data.slice(*KEYS_OF_CREATE_SHIPMENT)
        dhl_api.post({ username: client.username, password: client.password }, request_params, path)
      end

      def track_shipments(data, language = "eng")
        path = "/tracking"
        request_params = data.slice(*KEYS_OF_TRACK_SHIPMENTS)
        headers = { "Accept-Language": language }
        dhl_api.get({ username: client.username, password: client.password }, request_params, path, headers)
      end

      def cancel_pickup(data)
        path = "/pickups/#{data[:dispatchConfirmationNumber]}"
        request_params = data.slice(:requestorName, :reason)
        dhl_api.delete({ username: client.username, password: client.password }, request_params, path)
      end

      def reconcile_bearer_token
        path = "/token"
        digested_password = Digest::SHA256.hexdigest(client.billing_password).upcase
        reconcile_api.post({ username: client.billing_username, password: digested_password }, path)
      end

      def reconcile_billing(data)
        path = "/billing"
        basic_params = { functionCode: "B", billingAccount: client.account_number }
        request_params = basic_params.merge(
          data.slice(:billingDateFrom, :billingDateTo, :invoiceNo, :withCredit),
        )
        reconcile_api.post(request_params, path, data[:bearerToken])
      end

      private

      def dhl_api
        Dhl::Express::Api.new({ sandbox: client.sandbox })
      end

      def reconcile_api
        Dhl::Express::ReconcileApi.new
      end

    end

  end

end
