# frozen_string_literal: true

RSpec.describe Dhl::Express::ReconcileApi do
  describe "#post" do
    subject { described_class.new.post(request_params, path, bearer_token_str) }

    let(:request_params) { { functionCode: "B", billingAccount: "account_number" } }
    let(:path) { "/billing" }
    let(:bearer_token_str) { "Bearer xxx" }
    let(:request_url) do
      "https://cship.dhl.com/APIService/api/v2/billing"
    end
    let(:response_body) { [{ invoiceNumber: "123" }] }

    context "when request success" do
      before do
        stub_request(:post, request_url)
          .with(body: request_params.to_json, headers: { Authorization: bearer_token_str })
          .to_return(body: response_body.to_json)
      end

      it { is_expected.to have_attributes(body: response_body.to_json) }
    end
  end
end
