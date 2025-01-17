# frozen_string_literal: true

RSpec.describe Dhl::Express::Methods do
  let(:client) do
    Dhl::Express::Client.new(
      {
        account_number: "account_number",
        username: "username",
        password: "password",
        billing_username: "billing_username",
        billing_password: "billing_password",
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

  describe "#reconcile_bearer_token" do
    subject { described_class.new(client).reconcile_bearer_token }

    before do
      expect_any_instance_of(Dhl::Express::ReconcileApi).to receive(:post).with(
        { username: "billing_username", password: "92072A6461CDE1F49FD289209E10A54DBAB0EF453A48126C51E54FB754F5B783" },
        "/token",
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end

  describe "#reconcile_billing" do
    subject { described_class.new(client).reconcile_billing(data) }

    let(:data) do
      {
        billingAccount: "billing_account",
        billingDateFrom: "2020-01-01",
        billingDateTo: "2020-01-31",
        withCredit: false,
        bearerToken: "Bearer xxx",
      }
    end

    before do
      expect_any_instance_of(Dhl::Express::ReconcileApi).to receive(:post).with(
        {
          functionCode: "B",
          billingAccount: "account_number",
          billingDateFrom: "2020-01-01",
          billingDateTo: "2020-01-31",
          withCredit: false,
        },
        "/billing",
        "Bearer xxx",
      ).and_return("success_response")
    end

    it { is_expected.to eq("success_response") }
  end
end
