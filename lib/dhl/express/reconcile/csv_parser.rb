# frozen_string_literal: true

module Dhl

  module Express

    module Reconcile

      class CsvParser

        DEFAULT_ROW_KEYS = %i[
          line_type shipment_number
          total_amount_incl_vat total_extra_charges_xc total_extra_charges_tax
          xc1_name xc1_total xc1_tax xc2_name xc2_total xc2_tax xc3_name xc3_total xc3_tax
          xc4_name xc4_total xc4_tax xc5_name xc5_total xc5_tax xc6_name xc6_total xc6_tax
          xc7_name xc7_total xc7_tax xc8_name xc8_total xc8_tax xc9_name xc9_total xc9_tax
        ].freeze

        attr_reader :file_path, :csv_table

        def initialize(file_path)
          @file_path = file_path
          @csv_table = CSV.table(file_path)
        end

        def execute(offset, amount, row_keys = %i[])
          csv_rows = @csv_table[offset..(amount - 1)]
          return [] if csv_rows.nil?

          keys = (row_keys.nil? || row_keys.empty?) ? DEFAULT_ROW_KEYS : row_keys
          data = []
          csv_rows.each do |row|
            next if row[:line_type] == "I" || row[:shipment_number].to_s.empty?

            data << row.to_h.slice(*keys)
          end
          data
        end

      end

    end

  end

end
