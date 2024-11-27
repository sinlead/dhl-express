# Dhl::Express

DHL API services for

- retrieve rates
- create shipment
- shipment tracking

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dhl-express'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhl-express

## Usage

### DHL Express - MyDHL API

https://developer.dhl.com/api-reference/dhl-express-mydhl-api#get-started-section/

#### Retrive Rates for a one piece shipment

```ruby
# be advised: not all params are listed in this example,  
# all the required params are listed, but optional ones may be left out  
data = {
  accountNumber: "123456789",
  originCountryCode: "TW",
  originCityName: "Taipei",
  destinationCountryCode: "CZ",
  destinationCityName: "Prague",
  weight: 1,
  length: 15,
  width: 10,
  height: 5,
  plannedShippingDate: "2024-02-19",
  isCustomsDeclarable: false,
  unitOfMeasurement: "metric",
}
response = Dhl::Express::Methods.new(dhl_client).retrieve_rates_for_one_piece(data)
```

#### Retrive Rates for a Multi-piece shipment

```ruby
# be advised: not all params are listed in this example,  
# all the required params are listed, but optional ones may be left out  
data = {
  customerDetails: {
    shipperDetails: {
      postalCode: "14800",
      cityName: "Prague",
      countryCode: "CZ",
    },
    receiverDetails: {
      postalCode: "14800",
      cityName: "Prague",
      countryCode: "CZ",
    },
  },
  plannedShippingDateAndTime: "2024-02-19T13:00:00GMT+00:00",
  unitOfMeasurement: "metric",
  isCustomsDeclarable: true,
  packages: [
    {
      weight: 10.5,
      dimensions: {
        length: 25,
        width: 35,
        height: 15,
      },
    },
  ],
}
response = Dhl::Express::Methods.new(dhl_client).retrieve_rates_for_multi_piece(data)
```

#### Create Shipment

```ruby
# be advised: not all params are listed in this example,  
# all the required params are listed, but optional ones may be left out  
data = {
  plannedShippingDateAndTime: "2024-02-19T13:00:00GMT+00:00",
  pickup: {
    isRequested: true,
    pickupDetails: {
      postalAddress: {
        postalCode: "14800",
        cityName: "Prague",
        countryCode: "CZ",
        addressLine1: "some street",
      },
      contactInformation: {
        phone: "+886987654321",
        companyName: "companyName",
        fullName: "fullName",
      },
    },
  },
  productCode: "D", # DHL Express Global Product code
  accounts: [
    {
      typeCode: "shipper",
      number: "123456789",
    },
  ],
  customerDetails: {
    shipperDetails: {
      postalAddress: {
        postalCode: "14800",
        cityName: "Prague",
        countryCode: "CZ",
        addressLine1: "some street",
      },
      contactInformation: {
        phone: "+886987654321",
        companyName: "companyName",
        fullName: "fullName",
      },
    },
    receiverDetails: {
      postalAddress: {
        postalCode: "14800",
        cityName: "Prague",
        countryCode: "CZ",
        addressLine1: "some street",
      },
      contactInformation: {
        phone: "+886987654321",
        companyName: "companyName",
        fullName: "fullName",
      },
    },
  },
  content: {
    packages: [
      {
        weight: 22.5,
        dimensions: {
          length: 10,
          width: 15,
          height: 20,
        },
      },
    ],
    isCustomsDeclarable: false,
    description: "shipment description",
    incoterm: "DAP", # The Incoterms rules
    unitOfMeasurement: "metric"
  },
}
response = Dhl::Express::Methods.new(dhl_client).create_shipment(data)
```

#### Track single or multiple DHL Express Shipments

```ruby
# be advised: not all params are listed in this example,  
# all the required params are listed, but optional ones may be left out  
data = {
  shipmentTrackingNumber: [0987654321],
}
language = "chi" # Format {3-character language code}
# If language is empty, default language is English.

response = Dhl::Express::Methods.new(dhl_client).track_shipments(data, language)
```

#### Cancel a pickup booking request

```ruby
# be advised: not all params are listed in this example,  
# all the required params are listed, but optional ones may be left out  
data = {
  dispatchConfirmationNumber: "123",
  requestorName: "aaa",
  reason: "bbb",
}
response = Dhl::Express::Methods.new(dhl_client).cancel_pickup
```

### DHL Billing API Service

由 DHL IT 後台協助建立 Billing API 帳號以及密碼。（與 DHL Express - MyDHL API 不同 username password，同個 account_number）。

#### Reconcile Bearer Token

```ruby
data = {
  username: "aaa",
  password: "92072A...", # Digest::SHA256.hexdigest("billing_password").upcase
}
response = Dhl::Express::Methods.new(dhl_client).reconcile_bearer_token(data)
response.header["Authorization"] # "Bearer xxx..."
```

#### Reconcile Billing

```ruby 
data = {
  billingDateFrom: "2024-10-01", # date range should not be greater than 14 days
  billingDateTo: "2024-01-07",
  withCredit: false,
  bearerToken: "Bearer xxx...", # retrieved from reconcile_bearer_token
}
response = Dhl::Express::Methods.new(dhl_client).reconcile_billing(data)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dhl-express. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dhl::Express project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dhl-express/blob/master/CODE_OF_CONDUCT.md).
