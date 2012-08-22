class PassbookController < ApplicationController
  before_filter :verify_anti_forge_token
  
  def pass
    send_file @token.pass_path, type: 'application/vnd.apple.pkpass', disposition: 'attachment', filename: "pass.pkpass"
  end
  
  def generate
    pass = Passbook::PKPass.new(passContents("Joe's Clothes").to_json)

    pass.addFiles ["passbook/assets/icon.png", "passbook/assets/icon@2x.png", "passbook/assets/logo.png", "passbook/assets/logo@2x.png"]

    puts pass
    pkpass_path = pass.create
    
    @token.update_attribute("pass_path", pkpass_path)
    
    if params[:d] == "t" then
      send_file pkpass_path, type: 'application/vnd.apple.pkpass', disposition: 'attachment', filename: "pass.pkpass"
    end
  end
  
  private
    def passContents(company_name)
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
      info[:description] = @token.product.business.description
      info[:storeLocations] = [
        # Example
        {
          :longitude => @token.product.business.longitude.to_f,
          :latitude => @token.product.business.latitude.to_f
        }
      ]
      
      # Barcode Setup
      barcode[:value] = @token.bargin.barcode
      barcode[:format] = "PKBarcodeFormatPDF417"
      barcode[:encoding] = "iso-8859-1"
      
      # Company Setup
      company[:name] = company_name
      company[:color][:foreground] = "rgb(250, 250, 250)"
      company[:color][:background] = "rgb(25, 25, 250)"
      
      # Discount
#      discount[:type] = "percentage"
      discount[:type] = @token.bargin.bargin_type
      discount[:key] = "discount"
      if discount[:type] == "percentage" then
        discount[:value] = @token.bargin.value.to_i
      else
        discount[:value] = @token.bargin.value
      end
      discount[:application] = @token.bargin.application
      discount[:field] = configure_discount(discount)

      discount[:expiration][:date][:value] = "1980-05-07T10:00-05:00"
      discount[:expiration][:date][:format] = "PKDateStyleShort"
      
      user[:username] = @token.user.name
      
      product[:sku] = "42903"
      
      {
        :formatVersion => 1,
        :passTypeIdentifier => "pass.com.mightbuy.bargin",
        :serialNumber => info[:serial],
        :teamIdentifier => "DK9N2M2GK6",
        :webServiceURL => "https://example.com/passes/",
        :authenticationToken => info[:authentication_token],
        :description => info[:description],
        :locations => info[:storeLocations],
        :barcode => {
          :message => barcode[:value],
          :format => barcode[:format],
          :messageEncoding => barcode[:encoding]
        },
        :organizationName => company[:name],
        :logoText => company[:name],
        :foregroundColor => company[:color][:foreground],
        :backgroundColor => company[:color][:background],
        :storeCard => {
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
                :numberStyle => "PKNumberStyleSpellOut",
                :label => "spelled out",
                :key => "numberStyle",
                :value => 200
              },
              {
                :key => "loc",
                :label => "localized to french",
                :value => "Oh my stars."
              },
              {
                :label => "in reals",
                :key => "currency",
                :value => 200,
                :currencyCode => "BRL"
              },
              {
                :dateStyle => "PKDateStyleFull",
                :label => "date full",
                :key => "dateFull",
                :value => "1980-05-07T10:00-05:00"
              },
              {
                :label => "time full",
                :key => "timeFull",
                :value => "1980-05-07T10:00-05:00",
                :timeStyle => "PKDateStyleFull"
              },
              {
                :dateStyle => "PKDateStyleShort",
                :label => "dateTime",
                :key => "dateTime",
                :value => "1980-05-07T10:00-05:00",
                :timeStyle => "PKDateStyleShort"
              },
              {
                :dateStyle => "PKDateStyleShort",
                :label => "rel style",
                :key => "relStyle",
                :value => "2012-04-24T10:00-05:00",
                :isRelative => true
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
    
    def verify_anti_forge_token
      @token = AntiForgeToken.find_by_value(params[:aftoken])
      token = @token
      if token then
        if !token.active then
          head :unauthorized
        else
          # token.update_attribute("active", false)
        end
      else
        head :unauthorized
      end
    end
end
