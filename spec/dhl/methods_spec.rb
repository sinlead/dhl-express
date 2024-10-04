# frozen_string_literal: true

RSpec.describe Dhl::Express::Methods do
  let(:client) do
    Dhl::Express::Client.new(
      {
        account_number: "account_number",
        username: "username",
        password: "password",
      },
    )
  end

  describe "#retrieve_rates_for_one_piece" do
    subject { described_class.new(client).retrieve_rates_for_one_piece(data) }

    let(:data) { { accountNumber: "account_number", originCountryCode: "TW" } }

    before do
      expect_any_instance_of(Dhl::Express::Api).to receive(:get).with(
        { username: "username", password: "password" },
        { accountNumber: "account_number", originCountryCode: "TW" },
        "/rates",
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end

  describe "#retrieve_rates_for_multi_piece" do
    subject { described_class.new(client).retrieve_rates_for_multi_piece(data) }

    let(:data) { { accounts: [{ typeCode: "shipper", number: "666" }] } }

    before do
      expect_any_instance_of(Dhl::Express::Api).to receive(:post).with(
        { username: "username", password: "password" },
        { accounts: [{ typeCode: "shipper", number: "666" }] },
        "/rates",
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end

  describe "#create_shipment" do
    subject { described_class.new(client).create_shipment(data) }

    let(:data) { { pickup: { isRequested: true } } }

    before do
      expect_any_instance_of(Dhl::Express::Api).to receive(:post).with(
        { username: "username", password: "password" },
        { pickup: { isRequested: true } },
        "/shipments",
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end

  describe "#track_shipments" do
    subject { described_class.new(client).track_shipments(data, language) }

    let(:data) { { shipmentTrackingNumber: %w[123 456] } }
    let(:language) { "chi" }

    before do
      expect_any_instance_of(Dhl::Express::Api).to receive(:get).with(
        { username: "username", password: "password" },
        { shipmentTrackingNumber: %w[123 456] },
        "/tracking",
        { "Accept-Language": "chi" },
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end

  describe "#cancel_pickup" do
    subject { described_class.new(client).cancel_pickup(data) }

    let(:data) { { dispatchConfirmationNumber: "123", requestorName: "aaa", reason: "bbb" } }

    before do
      expect_any_instance_of(Dhl::Express::Api).to receive(:delete).with(
        { username: "username", password: "password" },
        { requestorName: "aaa", reason: "bbb" },
        "/pickups/123",
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end
end
