# frozen_string_literal: true

module Dhl

  module Express

    module Reconcile

      class CsvDownloader

        class FileNotReadyError < StandardError; end

        attr_reader :download_directory, :zip_file_path, :reconcile_file_path, :sand_box

        def initialize(account, password, download_directory, options = {})
          @account = account
          @password = password
          @dhl_reconcile_url = "https://mybill.dhl.com/"
          @download_directory = download_directory
          @zip_file_path = "#{@download_directory}DocumentDownload.zip"
          @reconcile_file_path = "#{@download_directory}dhlreconcile-#{Time.now.strftime('%Y-%m-%d')}.csv"
          @sand_box = options[:sand_box] || false
        end

        def execute
          return if @sand_box

          FileUtils.mkdir_p(@download_directory)
          setup_selenium_driver
          login
          select_reconciles_in_dashboard_page
          configure_in_download_selection
          click_download_in_downloads_page
          wait_for_zip_file_download_complete
          extract_zip_file

          { success: true }
        ensure
          logout_and_quit if defined? @driver
        end

        private

        def setup_selenium_driver
          prefs = { "download.default_directory": @download_directory }
          args = [
            "--headless=new",
            "--window-size=1440,900",
            "--disable-dev-shm-usage",
            "--no-sandbox",
            "--disable-gpu",
            "disable-infobars",
          ]
          options = Selenium::WebDriver::Chrome::Options.new(prefs:, args:)
          @driver = Selenium::WebDriver.for(:chrome, options:)
          @driver.manage.timeouts.implicit_wait = 10
        end

        def login
          @driver.navigate.to("#{@dhl_reconcile_url}login/?next=/dashboard/")
          @driver.find_element(id: "onetrust-reject-all-handler").click
          login_form = @driver.find_element(id: "loginBanner").find_element(tag_name: "form")
          login_form.find_element(id: "id_email").send_keys(@account)
          login_form.find_element(id: "id_password").send_keys(@password)
          login_form.find_element(id: "submitbutton").find_element(tag_name: "button").click
          sleep(1)
        end

        def select_reconciles_in_dashboard_page
          @driver.find_element(id: "dashtable")
                 .find_element(tag_name: "thead")
                 .find_elements(xpath: "./tr/th")
                 .first
                 .find_element(tag_name: "a")
                 .click
          @driver.find_element(id: "invoicesOpen").find_element(id: "download_button_id").click
          sleep(1)
        end

        def configure_in_download_selection
          @driver.find_element(id: "Express_csv2").find_element(xpath: "./../a").click
          @driver.find_element(id: "Express_csv2concat").find_element(xpath: "./../a").click
          @driver.find_element(id: "csv_selected").find_element(xpath: "./../button").click
          sleep(1)
        end

        def click_download_in_downloads_page(retry_file = 0, retry_stale = 0)
          latest_download_row = @driver.find_element(id: "downloads_table_body").find_elements(xpath: "./tr").first
          download_td = latest_download_row.find_elements(xpath: "./td").last
          download_span = download_td.find_elements(xpath: "./span").first
          raise FileNotReadyError if download_span.attribute("class") == "progess"

          download_span.find_element(xpath: "./a").click
        rescue FileNotReadyError
          raise "file still in progress" if retry_file > 10

          sleep(rand(1.0..3.0).round(1))
          click_download_in_downloads_page(retry_file + 1, retry_stale)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          raise "stale element retry limit reached" if retry_stale > 50

          click_download_in_downloads_page(retry_file, retry_stale + 1)
        end

        def wait_for_zip_file_download_complete(retry_count = 0)
          sleep(3)
          return if File.exist?(@zip_file_path)

          raise "takes too long to download zip file" if retry_count > 10

          wait_for_zip_file_download_complete(retry_count + 1)
        end

        def extract_zip_file
          FileUtils.rm(@reconcile_file_path) if File.exist?(@reconcile_file_path)

          Zip::File.open(@zip_file_path) do |zip_file|
            zip_file.each do |entry|
              entry.extract(@reconcile_file_path)
            end
          end
        ensure
          FileUtils.rm(@zip_file_path) if File.exist?(@zip_file_path)
        end

        def logout_and_quit
          @driver.execute_script("document.location.href = '#{@dhl_reconcile_url}logout/';")
          @driver.quit
        end

      end

    end

  end

end
