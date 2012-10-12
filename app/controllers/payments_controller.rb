class PaymentsController < ApplicationController
  before_filter :find_product

  def processP
    @price = (@product.price*100).to_i
    @description = @product.name
    if params[:stripeToken]
      # set your secret key: remember to change this to your live secret key in production
      # see your keys here https://manage.stripe.com/account
      Stripe.api_key = "yWcToOqt2pR0lS7x9TfghFTW4dQHxLKV"

      # get the credit card details submitted by the form
      token = params[:stripeToken]

      # create the charge on Stripe's servers - this will charge the user's card
      charge = Stripe::Charge.create(
        :amount => @price, # amount in cents, again
        :currency => "usd",
        :card => token,
        :description => @description
      )
      @message = charge.to_json
      puts "m: ", @message
      
      render :text => @message
    end
  end
  
  private
    def find_product
      @product = Topic.find_by_shortcode(params[:topic_shortcode]).product
    end
end
