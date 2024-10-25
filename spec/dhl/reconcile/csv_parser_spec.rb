# frozen_string_literal: true

RSpec.describe Dhl::Express::Reconcile::CsvParser do
  describe "#execute" do
    subject { described_class.new(file_path).execute(offset, amount) }

    let(:file_path) { "spec/fixtures/reconcile.csv" }

    context "when offset 0 amount 10" do
      let(:offset) { 0 }
      let(:amount) { 10 }

      it "should return correct data" do
        expect(subject).to eq(
          [
            {
              line_type: "S",
              shipment_number: 6666666666,
              total_amount_incl_vat: 1367.0,
              total_extra_charges_xc: 292.0,
              total_extra_charges_tax: 14.0,
              xc1_name: "FUEL SURCHARGE",
              xc1_total: 281.0,
              xc1_tax: 13.0,
              xc2_name: "GOGREEN PLUS - CARBON REDUCED",
              xc2_total: 25.0,
              xc2_tax: 1.0,
              xc3_name: 0,
              xc3_total: 0,
              xc3_tax: 0,
              xc4_name: 0,
              xc4_total: 0,
              xc4_tax: 0,
              xc5_name: 0,
              xc5_total: 0,
              xc5_tax: 0,
              xc6_name: 0,
              xc6_total: 0,
              xc6_tax: 0,
              xc7_name: 0,
              xc7_total: 0,
              xc7_tax: 0,
              xc8_name: 0,
              xc8_total: 0,
              xc8_tax: 0,
              xc9_name: 0,
              xc9_total: 0,
              xc9_tax: 0
            },
            {
              line_type: "S",
              shipment_number: 8888888888,
              total_amount_incl_vat: 1367.0,
              total_extra_charges_xc: 292.0,
              total_extra_charges_tax: 14.0,
              xc1_name: "FUEL SURCHARGE",
              xc1_total: 281.0,
              xc1_tax: 13.0,
              xc2_name: "GOGREEN PLUS - CARBON REDUCED",
              xc2_total: 25.0,
              xc2_tax: 1.0,
              xc3_name: 0,
              xc3_total: 0,
              xc3_tax: 0,
              xc4_name: 0,
              xc4_total: 0,
              xc4_tax: 0,
              xc5_name: 0,
              xc5_total: 0,
              xc5_tax: 0,
              xc6_name: 0,
              xc6_total: 0,
              xc6_tax: 0,
              xc7_name: 0,
              xc7_total: 0,
              xc7_tax: 0,
              xc8_name: 0,
              xc8_total: 0,
              xc8_tax: 0,
              xc9_name: 0,
              xc9_total: 0,
              xc9_tax: 0
            },
            {
              line_type: "S",
              shipment_number: 9999999999,
              total_amount_incl_vat: 1367.0,
              total_extra_charges_xc: 292.0,
              total_extra_charges_tax: 14.0,
              xc1_name: "FUEL SURCHARGE",
              xc1_total: 281.0,
              xc1_tax: 13.0,
              xc2_name: "GOGREEN PLUS - CARBON REDUCED",
              xc2_total: 25.0,
              xc2_tax: 1.0,
              xc3_name: 0,
              xc3_total: 0,
              xc3_tax: 0,
              xc4_name: 0,
              xc4_total: 0,
              xc4_tax: 0,
              xc5_name: 0,
              xc5_total: 0,
              xc5_tax: 0,
              xc6_name: 0,
              xc6_total: 0,
              xc6_tax: 0,
              xc7_name: 0,
              xc7_total: 0,
              xc7_tax: 0,
              xc8_name: 0,
              xc8_total: 0,
              xc8_tax: 0,
              xc9_name: 0,
              xc9_total: 0,
              xc9_tax: 0
            },
          ]
        )
      end
    end
  end
end
