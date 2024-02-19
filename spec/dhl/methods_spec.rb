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
    subject { described_class.new(client).track_shipments(data) }

    let(:data) { { shipmentTrackingNumber: %w[123 456] } }

    before do
      expect_any_instance_of(Dhl::Express::Api).to receive(:get).with(
        { username: "username", password: "password" },
        { shipmentTrackingNumber: %w[123 456] },
        "/tracking",
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end
end
