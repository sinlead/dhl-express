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

      def track_shipments(data)
        path = "/tracking"
        request_params = data.slice(*KEYS_OF_TRACK_SHIPMENTS)
        dhl_api.get({ username: client.username, password: client.password }, request_params, path)
      end

      private

      def dhl_api
        Dhl::Express::Api.new({ sandbox: client.sandbox })
      end

    end

  end

end
