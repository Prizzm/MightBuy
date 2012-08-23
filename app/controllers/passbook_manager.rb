class PassbookManager < ApplicationController
  before_filter :verify_anti_forge_token
  
  def generatePass(token)
    puts passContents(token).to_json
    pass = Passbook::PKPass.new(passContents(token).to_json)
    pass.addFiles ["passbook/assets/icon.png", "passbook/assets/icon@2x.png", "passbook/assets/logo.png", "passbook/assets/logo@2x.png"]
    pass.create
  end
  private
    def passContents(token)
      # Arrays
      info = {}
      barcode = {}
      company = {}
      company[:color] = {}
      discount = {}
      discount[:expiration] = {}
      discount[:expiration][:date] = {}
      user = {}
      product = {}
      # Main Info
      info[:serial] = SecureRandom.hex(20)
      info[:authentication_token] = SecureRandom.hex(20)
      info[:description] = token.product.business.description
      info[:storeLocations] = [
        # Example
        {
          :longitude => -122.406417,
          :latitude => 37.785834
        }
      ]
    
      # Barcode Setup
      barcode[:value] = token.bargin.barcode
      barcode[:format] = "PKBarcodeFormatPDF417"
      barcode[:encoding] = "iso-8859-1"
    
      # Company Setup
      company[:name] = token.product.business.name
      company[:color][:foreground] = "rgb(#{token.product.business.foreground_color[0]}, #{token.product.business.foreground_color[1]}, #{token.product.business.foreground_color[2]})"
      company[:color][:background] = "rgb(#{token.product.business.background_color[0]}, #{token.product.business.background_color[1]}, #{token.product.business.background_color[2]})"
    
      # Discount
  #      discount[:type] = "percentage"
      discount[:type] = token.bargin.bargin_type
      discount[:key] = "discount"
      if discount[:type] == "percentage" then
        discount[:value] = token.bargin.value.to_i
      else
        discount[:value] = token.bargin.value
      end
      discount[:application] = token.bargin.application
      discount[:field] = configure_discount(discount)

      discount[:expiration][:date][:value] = "1980-05-07T10:00-05:00"
      discount[:expiration][:date][:format] = "PKDateStyleShort"
    
      user[:username] = token.user.name
    
      product[:sku] = "42903"
      
      # Setup Token
      token.update_attribute("serial_number", info[:serial])
      token.update_attribute("authorization_token", info[:authentication_token])
    
      {
        :formatVersion => 1,
        :passTypeIdentifier => "pass.mightbuy.bargin",
        :serialNumber => info[:serial],
        :teamIdentifier => "DK9N2M2GK6",
        :webServiceURL => "https://mightbuy.it/passbook/passes/",
        :authenticationToken => info[:authentication_token],
        :description => info[:description],
        :locations => info[:storeLocations],
        :barcode => {
          :message => barcode[:value],
          :alttext => barcode[:value],
          :format => barcode[:format],
          :messageEncoding => barcode[:encoding]
        },
        :organizationName => company[:name],
        :logoText => company[:name],
        :foregroundColor => company[:color][:foreground],
        :backgroundColor => company[:color][:background],
        :coupon => {
            :primaryFields => [
              discount[:field]
            ],
            :secondaryFields => [
              {
                :dateStyle => discount[:expiration][:date][:format],
                :key => "expires",
                :label => "EXPIRES",
                :value => discount[:expiration][:date][:value]
              }
            ],
            :auxiliaryFields => [
              {
                :key => "username",
                :label => "USERNAME",
                :value => user[:username]
              },
              {
                :key => "sku",
                :label => "SKU",
                :value => product[:sku],
                :textAlignment => "PKTextAlignmentRight"
              }
            ],
            :backFields => [
              {
                :key => "terms",
                :label => "TERMS",
                :value => 'We make no express or implied warranties or representations with respect to the Program or any products sold through the Program (including, without limitation, warranties of fitness, merchantability, non-infringement, or any implied warranties arising out of a course of performance, dealing, or trade usage). In addition, we make no representation that the operation of our site will be uninterrupted or error-free, and we will not be liable for the consequences of any interruptions or errors. We may change, restrict access to, suspend or discontinued the site or any part of it at anytime. The information, content and services on the site are provided on an "as is" basis. When you use the site and or participate therein, you understand and agree that you participate at your own risk.'
              }
            ]
          }
      }
    end
  
    def configure_discount(data)
      field = {}
      if data[:type] == "percentage" then
        field[:key] = data[:key]
        field[:value] = "#{data[:value]}%"
        field[:label] = data[:application]
      elsif data[:type] == "fixed"
        field[:key] = data[:key]
        field[:value] = data[:value]
        field[:label] = data[:application]
        field[:currencyCode] = "USD"
      end
      return field
    end
end