class UsersController < RestfulController

  actions :index, :show

  protected

  def end_of_association_chain
    super.people
  end

  def collection
    @users ||= end_of_association_chain.order(:name)
  end

end
