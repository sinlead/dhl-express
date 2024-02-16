# frozen_string_literal: true

RSpec.describe Dhl::Express::Api do
  describe "#get" do
    subject { described_class.new.get(auth, request_params, path) }

    let(:auth) { { username: "username", password: "password" } }
    let(:request_params) { { accountNumber: "666", length: "1", width: "2", height: "3" } }
    let(:path) { "/rates" }
    let(:request_url) do
      "https://express.api.dhl.com/mydhlapi/rates?accountNumber=666&length=1&width=2&height=3"
    end
    let(:response_body) { { products: ["some_stuff"] } }

    context "when request success" do
      before do
        stub_request(:get, request_url).to_return(body: response_body.to_json)
      end

      it { is_expected.to have_attributes(body: response_body.to_json) }
    end
  end

  describe "#post" do
    subject { described_class.new.post(auth, request_params, path) }

    let(:auth) { { username: "username", password: "password" } }
    let(:request_params) { { pickup: { isRequested: true } } }
    let(:path) { "/shipments" }
    let(:request_url) do
      "https://express.api.dhl.com/mydhlapi/shipments"
    end
    let(:response_body) { { shipmentTrackingNumber: "123" } }

    context "when request success" do
      before do
        stub_request(:post, request_url).with(body: request_params.to_json).to_return(body: response_body.to_json)
      end

      it { is_expected.to have_attributes(body: response_body.to_json) }
    end
  end
end
