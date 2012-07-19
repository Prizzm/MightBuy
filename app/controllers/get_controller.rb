class GetController < ApplicationController
  def images 
    respond_to do |wants|
      wants.json { render :json => Scrape.images(params[:url]) }
    end
  end
  
  def product 
    respond_to do |wants|
      wants.json { render :json => Scrape.product(params[:url]) }
    end
  end
end