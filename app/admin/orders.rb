ActiveAdmin.register Order do
  show do
    attributes_table do
      row :id
      row :fulfilled
      row "Card" do |order|
        table do
          tr do
            td "id"
            td order.card.id
          end          
          tr do
            td "address_city"
            td order.card.address_city
          end
          tr do
            td "address_country"
            td order.card.address_country
          end
          tr do
            td "address_line1"
            td order.card.address_line1
          end
          tr do
            td "address_line1_check"
            td order.card.address_line1_check
          end
          tr do
            td "address_line2"
            td order.card.address_line2
          end
          tr do
            td "address_line2_check"
            td order.card.address_line2_check
          end
          tr do
            td "address_state"
            td order.card.address_state
          end
          tr do
            td "address_zip"
            td order.card.address_zip
          end
          tr do
            td "address_zip_check"
            td order.card.address_zip_check
          end
          tr do
            td "country"
            td order.card.country
          end
          tr do
            td "cvc_check"
            td order.card.cvc_check
          end
          tr do
            td "exp_month"
            td order.card.exp_month
          end
          tr do
            td "exp_year"
            td order.card.exp_year
          end
          tr do
            td "fingerprint"
            td order.card.fingerprint
          end
          tr do
            td "last4"
            td order.card.last4
          end
          tr do
            td "name"
            td order.card.name
          end
          tr do
            td "card_object"
            td order.card.card_object
          end
          tr do
            td "card_type"
            td order.card.card_type
          end
          tr do
            td "created_at"
            td order.card.created_at
          end
          tr do
            td "updated_at"
            td order.card.updated_at
          end
          
          
        end
      end
      row :user do |order|
        order.topic.user
      end  
      row :product
      row :topic
      row :invoice
      row :amount
      row :amount_refunded
      row :created_stripe
      row :currency
      row :customer
      row :description
      row :disputed
      row :failure_message
      row :fee
      row :invoice
      row :livemode
      row :object
      row :paid
      row :refunded
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end  
end
