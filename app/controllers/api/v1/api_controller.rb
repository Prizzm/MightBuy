class Api::V1::ApiController < ApplicationController

  private
  def present(api_response, options = {})
    body_hash = options[:with].represent(api_response)
    render :json => body_hash, :status => options[:status]
  end
end
