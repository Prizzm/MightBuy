class Users::ProfileController < Brands::BaseController
  
  def begin_of_association_chain
    current_user
  end
  
end