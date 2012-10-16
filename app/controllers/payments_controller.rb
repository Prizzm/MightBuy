class PaymentsController < ApplicationController
  before_filter :find_product, :except => ["confirmation"]

  def processP
    begin
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
      
        jm = charge
        order = Order.new()
        card = Card.new()
        order.invoice_id = jm.id
        order.amount = jm.amount
        order.amount_refunded = jm.amount_refunded
        order.created_stripe = jm.created
        order.currency = jm.currency
        order.customer = jm.customer
        order.description = jm.description
        order.disputed = jm.description
        order.failure_message = jm.failure_message
        order.fee = jm.fee
        order.invoice = jm.invoice
        order.livemode = jm.livemode
        order.object = jm.object
        order.paid = jm.paid
        order.refunded = jm.refunded
      
        card.address_city = jm.card.address_city
        card.address_country = jm.card.address_country
        card.address_line1 = jm.card.address_line1
        card.address_line1_check = jm.card.address_line1_check
        card.address_line2 = jm.card.address_line2
        card.address_state = jm.card.address_state
        card.address_zip = jm.card.address_zip
        card.address_zip_check = jm.card.address_zip_check
        card.country = jm.card.country
        card.cvc_check = jm.card.cvc_check
        card.exp_month = jm.card.exp_month
        card.exp_year = jm.card.exp_year
        card.fingerprint = jm.card.fingerprint
        card.last4 = jm.card.last4
        card.name = jm.card.name
        card.card_object = jm.card.object
        card.card_type = jm.card.type
        card.save()
        order.card = card      
      
        order.user = current_user
        order.topic = @topic
        order.product = @product
      
        jm.fee_details.each do |feeObj|
          fee = Fee.new()
          fee.fee_type = feeObj.type
          fee.application = feeObj.application
          fee.currency = feeObj.currency
          fee.amount = feeObj.amount
          fee.description = feeObj.description
          fee.save()
        
          order.fees << fee
        end
      
        order.save()
      
        redirect_to("http://localhost:3000/orders/#{params[:topic_shortcode]}/#{order.invoice_id}/confirmation")
      end
    rescue
      render :text => "A error has occured.  This is a very important issue to us, please contact us at contact@mightbuy.it"
    end
  end
  
  def confirmation
    @order = Order.find_by_invoice_id(params[:invoice_id])
  end
  
  private
    def find_product
      @topic = Topic.find_by_shortcode(params[:topic_shortcode])
      @product = @topic.product
    end
end