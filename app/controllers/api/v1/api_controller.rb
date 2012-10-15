class Api::V1::ApiController < ApplicationController

  private
  def present(api_response, options = {})
    if options[:raw] == true
      body_hash = api_response
    else
      body_hash = options[:with].represent(api_response)
    end
    render :json => body_hash, :status => options[:status]
  end
end
