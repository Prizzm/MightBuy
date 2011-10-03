class Brands::ReviewsController < Brands::BaseController
  
  def begin_of_association_chain
    current_brand
  end
  
end