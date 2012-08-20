class BrandsController < UsersController
  
  protected
  
    def end_of_association_chain
      super.brands  
    end
  
end