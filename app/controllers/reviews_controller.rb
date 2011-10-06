class ReviewsController < InheritedResources::Base

  # Authenticate
  before_filter :authenticate_user!
  
  # Relationships
  belongs_to :product
  
  # Custom Actions
  custom_actions :collection => [:feedback, :thanks]
  
  # Actions
  
  def create
    @review = parent.reviews.find_by_user_id(current_user.id) || end_of_association_chain.new
    @review.attributes = params[:review]
    @review.user = current_user
    create! do |format|
      format.html { redirect_to params[:redirect_to] || resource_path(@review) }
    end
  end
  
  # Methods
  
  helper_method :brand
  
  def brand
    parent.brand
  end
  
end